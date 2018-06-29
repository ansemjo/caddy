# Copyright 2018 Anton Semjonov
# Licensed under the MIT License

FROM alpine:3.7

LABEL maintainer="Anton Semjonov <anton@semjonov.de>"
LABEL license="MIT License"

RUN echo 'install build and runtime dependencies ...' \
  && apk add --no-cache -t build-deps git go libcap musl-dev \
  && apk add --no-cache -t runtime-deps python2 python3 dnsmasq \
  && export GOPATH="/go" \
  && echo 'checkout sources ...' \
  && go get -u github.com/mholt/caddy \
  && go get -u github.com/caddyserver/builds \
  && go get -u github.com/jung-kurt/caddy-cgi \
  && cd "$GOPATH/src/github.com/mholt/caddy/caddy" \
  && echo 'patch run.go ...' \
  && sed -i 's/\(enableTelemetry = \)true/\1false/' caddymain/run.go \
  && sed -i $'/caddy\/caddyhttp/a\ \t_ "github.com/jung-kurt/caddy-cgi"' caddymain/run.go \
  && echo 'build binary ...' \
  && go run build.go \
  && setcap cap_net_bind_service=+ep caddy \
  && setcap cap_net_bind_service=+ep /usr/sbin/dnsmasq \
  && mv caddy /usr/local/bin/ \
  && echo 'remove build dependencies ...' \
  && apk del --purge build-deps 2>/dev/null \
  && cd / \
  && rm -rf "$GOPATH" \
  && mkdir -p /srv \
  && caddy -version

WORKDIR /srv
USER nobody

COPY ["index.html", "/srv/"]
COPY ["caddyfile", "/etc/"]

ENTRYPOINT ["/usr/local/bin/caddy"]
CMD ["-conf", "/etc/caddyfile"]
