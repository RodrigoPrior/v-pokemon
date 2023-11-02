module main

import vweb
import net.http

struct App {
	vweb.Context
}

fn main() {
	mut app := App{}
	// app.serve_static('/docs', '.src/assets/docs')
	app.host_mount_static_folder_at('localhost', './src/assets/docs', '/docs')
	vweb.run(app, 8080)
}

pub fn (mut app App) index() vweb.Result {
	return app.text('Hello world from v!')
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
	response := http.get_text(url)
	app.add_header('Content-Type', 'application/json')
	return app.text(response)
}
