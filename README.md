# ansemjo/caddy

[![](https://img.shields.io/docker/pulls/ansemjo/caddy.svg?style=flat-square)](https://hub.docker.com/r/ansemjo/caddy)

A container image containing the [caddy] server in two variants:

- [`Proxy`](#proxy) - completely standalone in a scratch base image for simple file server or
  proxying scenarios
- [`CGI`](#cgi) - with [CGI support] and in a Python base image for simple dynamic content

[caddy]: https://caddyserver.com/
[cgi support]: https://caddyserver.com/docs/http.cgi

## Proxy

![](https://img.shields.io/microbadger/image-size/ansemjo/caddy/proxy.svg?style=flat-square)
![](https://img.shields.io/microbadger/layers/ansemjo/caddy/proxy.svg?style=flat-square)

This is the simpler image because it is intended to be used as a TLS proxy for internal services or
as one element in a `docker-compose.yml` file. The `caddy` binary is compiled statically and
stripped of all symbols, then placed in an empty `scratch` image.

### Usage

Since its main purpose is a TLS proxy, the included `caddyfile` requires a certificate to be
present, redirects all plaintext requests to use HTTPS and proxies every request to a backend
application.

- The location of the certificate can be customized with the `CADDY_TLS` environment variable. It is
  `/tls` by default.
- The proxied backend is given in `CADDY_UPSTREAM`.

```sh
docker run -d \
  -p 80:80 -p 443:443 \
  -v $PWD/server.key:/tls/server.key \
  -v $PWD/server.crt:/tls/server.crt \
  -e CADDY_UPSTREAM=myapplication:8080 \
  ansemjo/caddy:proxy
```

If you want to do something else you can mount a custom configuration file over `/caddyfile`:

```sh
...
  -v $PWD/caddyfile:/caddyfile \
...
```

### Building

```sh
docker build -t caddy:proxy proxy/
```

## CGI

![](https://img.shields.io/microbadger/image-size/ansemjo/caddy/cgi.svg?style=flat-square)
![](https://img.shields.io/microbadger/layers/ansemjo/caddy/cgi.svg?style=flat-square)

This image is built with [jung-kurt/caddy-cgi](https://github.com/jung-kurt/caddy-cgi) compiled in
to enable CGI support. That means you can have scripts on the server that will be used to construct
the actual response dynamically without writing a full-blown application server. This has its
drawbacks of course. But it works great for simple dynamically generated content like menu scripts
for network booting with iPXE or Kickstart configurations, for example. To that end, this image
plays together nicely with [ansemjo/ipxeboot](https://github.com/ansemjo/ipxeboot).

### Usage

The included `caddyfile` is much simpler and only uses plain HTTP by default. A small
[Python sample](cgi/hello.py) is included.

- Mount your files in the webroot at `/srv/www`.

```sh
docker run -d \
  -p 80:80 \
  -v $PWD/webroot:/srv/www \
  ansemjo/caddy:cgi
```

If you don't mount anything in `/srv/www` and simply run a test with
`docker run --rm -d -p 80:80 ansemjo/caddy:cgi` you can check that the CGI script is working by
visiting `http://localhost/hello.py?name=Yourname`:

```sh
$ curl http://localhost/hello.py?name=$(whoami)
// Saturday, 16. February 2019, 23:03:09
Hello, ansemjo!
```

Again, if you want to configure how your CGI scripts work or enable other features, mount your own
configuration over `/caddyfile` (see above).

### Building

```sh
docker build -t caddy:cgi cgi/
```

## Licensing

### Caddy

The caddy binary (`/caddy`) is built from sources and as such is licensed under the [Apache License
2.0]. Changes made to its sources can be seen in the [dockerfile] and include:

- disable telemetry
- include `jung-kurt/caddy-cgi` plugin

[apache license 2.0]: https://github.com/mholt/caddy/blob/master/LICENSE.txt
[dockerfile]: dockerfile#L14

### Caddy-CGI

The included [caddy-cgi] plugin is licensed under the [MIT License].

[caddy-cgi]: https://github.com/jung-kurt/caddy-cgi
[mit license]: https://github.com/jung-kurt/caddy-cgi/blob/master/LICENSE

### This project

This work is licensed under the [MIT License](LICENSE).
