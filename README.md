# ansemjo/caddy

A container image containing the [caddy] server in two variants:

- `ansemjo/caddy:plain` – completely standalone in a scratch base image for simple file server or
  proxying scenarios
- `ansemjo/caddy:cgi` – with [CGI support] in a Python base image for simple dynamic content

Both images can quickly be build with `build.sh` if you have a BuildKit-enabled Docker.

[caddy]: https://caddyserver.com/
[CGI support]: https://github.com/aksdb/caddy-cgi/

## `plain`

This is the simpler image because it is intended to be used as a TLS proxy for internal services or
as one element in a `docker-compose.yml` file. The `caddy` binary is compiled statically and
stripped of all symbols, then placed in an empty `scratch` image.

### Usage

The Caddyfile in the image only activates a file browser in its root `/srv/www` and
nothing more.

    docker run -d -p 8080:8080 \
      -v /path/to/files:/srv/www \
      ansemjo/caddy:plain

If you want to do something else you can also mount a custom configuration file
over `/Caddyfile`:

    docker run -d -p 8080:8080 \
      -v /path/to/files:/srv/www \
      -v $PWD/Caddyfile:/Caddyfile \
      ansemjo/caddy:plain


## `cgi`

This image uses the same `caddy` binary as above, which is built with
[aksdb/caddy-cgi](https://github.com/aksdb/caddy-cgi/) compiled-in, and is placed
in a Python base image.

That means that you can have a few simple scripts in the container that will be used
to construct the actual response dynamically without writing a full-blown application
server. This has its drawbacks of course, mainly performance. But it works great for
simple dynamically generated content like menu scripts for network booting with iPXE
or Kickstart configurations, for example. To that end, this image plays together nicely
with [ansemjo/ipxeboot](https://github.com/ansemjo/ipxeboot).

### Usage

The included `Caddyfile` handles any `/*.py` files in its `/srv/www` webroot as
Pyhton scripts and executes them with Python 3. A small sample is included in
`/srv/www/hello.py`.

    docker run -d -p 8080:8080 \
      -v /path/to/files:/srv/www \
      ansemjo/caddy:cgi

Again, if you want to configure how your CGI scripts are handled or enable other
features, mount your own configuration over `/Caddyfile` (see above).


## License

### caddy

The caddy binary is built from sources and as such is licensed under
the [Apache License 2.0]. No changes are made directly to its sources but an
own `main.go` file is used to enable the plugin below.

[Apache License 2.0]: https://github.com/caddyserver/caddy/blob/master/LICENSE

### caddy-cgi

The included [caddy-cgi] plugin is licensed under the [MIT License].

[caddy-cgi]: https://github.com/aksdb/caddy-cgi/
[MIT License]: https://github.com/aksdb/caddy-cgi/blob/master/LICENSE

### this project

This work is licensed under the [MIT License](LICENSE).
