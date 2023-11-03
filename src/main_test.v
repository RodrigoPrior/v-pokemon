import os
import time
// import json
import net
import net.http
// import io

const (
	sport           = 8080
	localserver     = '127.0.0.1:${sport}'
	exit_after_time = 12000 // milliseconds
	vexe            = os.getenv('VEXE')
	vweb_logfile    = os.getenv('VWEB_LOGFILE')
	vroot           = os.dir(vexe)
	serverexe       = os.join_path(os.cache_dir(), 'test_client')
	projectbin      = os.getwd()
	tcp_r_timeout   = 30 * time.second
	tcp_w_timeout   = 30 * time.second
)

// setup of vweb webserver
fn testsuite_begin() {
	os.chdir(vroot) or {}
	if os.exists(serverexe) {
		os.rm(serverexe) or {}
	}
}

fn test_a_simple_vweb_app_can_be_compiled() {
	// did_server_compile := os.system('${os.quoted_path(vexe)} -g -o ${os.quoted_path(serverexe)} vlib/vweb/tests/vweb_test_server.v')
	// TODO: find out why it does not compile with -usecache and -g
	did_server_compile := os.system('${os.quoted_path(vexe)} -o ${os.quoted_path(serverexe)} ${projectbin}')
	assert did_server_compile == 0
	assert os.exists(serverexe)
}

fn test_a_simple_vweb_app_runs_in_the_background() {
	mut suffix := ''
	$if !windows {
		suffix = ' > /dev/null &'
	}
	if vweb_logfile != '' {
		suffix = ' 2>> ${os.quoted_path(vweb_logfile)} >> ${os.quoted_path(vweb_logfile)} &'
	}
	server_exec_cmd := '${os.quoted_path(serverexe)} ${sport} ${exit_after_time} ${suffix}'
	$if debug_net_socket_client ? {
		eprintln('running:\n${server_exec_cmd}')
	}
	$if windows {
		spawn os.system(server_exec_cmd)
	} $else {
		res := os.system(server_exec_cmd)
		assert res == 0
	}
	$if macos {
		time.sleep(1000 * time.millisecond)
	} $else {
		time.sleep(100 * time.millisecond)
	}
}

// net.http client based tests follow:
fn assert_common_http_headers(x http.Response) ! {
	assert x.status() == .ok
	assert x.header.get(.server)! == 'VWeb'
	assert x.header.get(.content_length)!.int() > 0
	assert x.header.get(.connection)! == 'close'
}

fn test_http_client_index() {
	x := http.get('http://${localserver}/') or { panic(err) }
	assert_common_http_headers(x)!
	assert x.header.get(.content_type)! == 'text/plain'
	assert x.body == 'Hello v-pokemon!'
}

fn test_http_client_404() {
	server := 'http://${localserver}'
	url_404_list := [
		'/zxcnbnm',
		'/JHKAJA',
		'/unknown',
	]
	for url in url_404_list {
		res := http.get('${server}${url}') or { panic(err) }
		assert res.status() == .not_found
		assert res.body.starts_with('404')
	}
}

fn test_http_client_real_pokemon() {
	x := http.get('http://${localserver}/v1/pokemon/ditto') or { panic(err) }
	assert x.status() == http.Status.ok
	assert x.header.get(.content_type)! == 'application/json'
}
