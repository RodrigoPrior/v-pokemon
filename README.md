# V lang - Pokemon API

Simple [v lang](https://vlang.io/) test API interface to [Pokéapi](https://pokeapi.co/).

[Swager](https://swagger.io/) served as static files at `/docs`.

# Development

```bash
    $ v watch run src
```

# Compile

```bash
    $ v src
    $ v -prod src # optimized binary
```

Obs.: statics from `/docs` are not compiled toguether with the final binary.

# TODO

- [ ] Makefile?
- [ ] Tests

# References

## Tests

- https://blog.vlang.io/elevate-your-v-project-with-unit-tests/
- https://github.com/vlang/v/blob/master/vlib/vweb/tests/vweb_test.v


