# docker-caddy-tftpd

This is a minimal Docker image containing [caddy] with [cgi support] and
[dnsmasq] acting as a TFTP server. It was created to be used as a very simple
file server for PXE booting and kickstarting Linux systems.

[caddy]: https://caddyserver.com/
[cgi support]: https://caddyserver.com/docs/http.cgi
[dnsmasq]: http://thekelleys.org.uk/dnsmasq/doc.html

## building the image

If you have [`make`] installed you can simply run `make` to build and tag the
image as `caddy:latest`.

[`make`]: https://www.gnu.org/software/make/

Otherwise use:

```sh
$ docker build -t caddy .
```

If you have access to the Docker registry in this GitLab, there should be an
automatically built image as a result of the [CI pipeline].

[CI pipeline]: .gitlab-ci.yml

## running the image

Example files [`/etc/caddyfile`] and [`/srv/index.html`] are included in the
image but the caddyfile expects TLS keys in `/run/tls.{crt,key}` by default.
Since the user in the container is switched to `nobody`, you must ensure that
`nobody` can access those keys. Alpine's `nobody` user has the UID `65534`,
which is `nfsnobody` on CentOS and similar systems.

Additionally, remember to publish the required ports: `dnsmasq` requires that
you publish port `69/udp`. You could also take the shortcut and use
`--network=host` of course.

[`/etc/caddyfile`]: caddyfile
[`/srv/index.html`]: index.html

Files are served via HTTP from `/srv` by default and the caddyfile used by the
preconfigured entrypoint and command is `/etc/caddyfile`. The TFTP root is in
`/srv/tftp` by default.

```sh
ls -la ./tls
total 8
drwx--x---. 1 root nfsnobody   28 Jun 15 00:10 .
drwxr-xr-x. 1 root root        50 Jun 15 02:17 ..
-rw-r-----. 1 root nfsnobody 1915 Jun 14 23:47 tls.crt
-rw-r-----. 1 root nfsnobody 1708 Jun 14 23:47 tls.key

docker run --rm -d \
    -p 69:69/udp \
    -p 80:80 \
    -p 443:443 \
    -v $PWD/tls:/run \
    -v /path/to/my/files:/srv \
    caddy-tftpd
336255aec9...83eb7b7b004991d
```

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