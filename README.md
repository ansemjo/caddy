# docker-caddy

This is a minimal Docker image with [caddy] and [cgi support].
It was created to be used as a very simple HTTP file server for PXE booting and
kickstarting Linux systems.

[caddy]: https://caddyserver.com/
[cgi support]: https://caddyserver.com/docs/http.cgi

## building the image

If you have [`make`] installed you can simply run `make` to build and tag the
image as `caddy:latest`.

[`make`]: https://www.gnu.org/software/make/

Otherwise use:

```sh
$ docker build -t caddy .
```

## running the image

Example files [`caddyfile`] and [`index.html`] are included in the image, so you
can simply run the following command and then access `http://localhost/`:

[`caddyfile`]: caddyfile
[`index.html`]: index.html

```sh
$ docker run --rm -d -p 80:80 caddy
```

Files are served from `/srv` by default and the caddyfile used by the
preconfigured entrypoint and command is `/etc/caddyfile`, so you can customize
caddy by mounting volumes there:

```sh
$ docker run --rm -d \
    -p 80:80 \
    -v /path/to/my/htdocs:/srv \
    -v /path/to/my/caddyfile:/etc/caddyfile \
    caddy
```

Or enable `tls` in the caddyfile and mount your certificate and key at
appropriate places if you are using selfsigned certificates. I'll leave that as
an exercise to the reader.

## licensing

### caddy

The caddy binary (`/usr/local/bin/caddy`) is built from sources and as such is
licensed under the [Apache License 2.0]. Changes made to its sources can be seen
in the [dockerfile]:

- disable Telemetry
- include jung-kurt/caddy-cgi plugin

[Apache License 2.0]: https://github.com/mholt/caddy/blob/master/LICENSE.txt
[dockerfile]: dockerfile#L14

### caddy-cgi

The included [caddy-cgi] plugin is licensed under the [MIT License].

[caddy-cgi]: https://github.com/jung-kurt/caddy-cgi
[MIT License]: https://github.com/jung-kurt/caddy-cgi/blob/master/LICENSE

### this work

This work is licensed under the [MIT License](LICENSE).