module main

import vweb
import net.http
import logger

struct App {
	vweb.Context
}

fn main() {
	// start log
	logger.start()
	// start server
	mut app := App{}
	// server swagger statics
	app.host_mount_static_folder_at('localhost', './src/assets/docs', '/docs')
	// start server on port
	logger.simple('debug', '[+] mensagem de amor')
	vweb.run(app, 8080)
}

pub fn (mut app App) index() vweb.Result {
	return app.text('Hello v-pokemon!')
}

['/docs']
pub fn (mut app App) content() vweb.Result {
	// call root swagger index
	content := $tmpl('assets/docs/index.html')
	return app.html(content)
}

['/v1/pokemon/:name'; get]
fn (mut app App) get_pokemon(name string) vweb.Result {
	// get the right pokemon
	url := 'https://pokeapi.co/api/v2/pokemon/${name}'
	res := http.get(url) or { panic(err) }
	// payload already in json format, send directly and set content-type
	app.set_content_type('application/json')
	logger.simple('info', '${res.status_code} - ${url} - ${res.status_msg}')
	return app.ok(res.body)
}
