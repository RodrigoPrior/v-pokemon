module main

import vweb
import net.http

struct App {
	vweb.Context
}

fn main() {
	app := App{}
	vweb.run(app, 8080)
}

pub fn (mut app App) index() vweb.Result {
	return app.text('Hello world from v!')
}

['/pokemon/:name'; get]
fn (mut app App) get_pokemon(name string) vweb.Result {
	// get the right pokemon
	url := 'https://pokeapi.co/api/v2/pokemon/${name}'
	response := http.get_text(url)
	app.add_header('Content-Type', 'application/json')
	return app.text(response)
}
