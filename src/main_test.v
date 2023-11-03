import os
import time
// import json
// import net
// import net.http
// import io

const (
	sport           = 9099
	localserver     = '127.0.0.1:${sport}'
	exit_after_time = 12000 // milliseconds
	vexe            = os.getenv('VEXE')
	vweb_logfile    = os.getenv('VWEB_LOGFILE')
	vroot           = os.dir(vexe)
	serverexe       = os.join_path(os.cache_dir(), 'v-pokemon')
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
