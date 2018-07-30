# Copyright 2018 Anton Semjonov
# Licensed under the MIT License

FROM golang:1.10-alpine

LABEL maintainer="Anton Semjonov <anton@semjonov.de>"
LABEL license="MIT License"

RUN echo 'install build and runtime dependencies ...' \
  && apk add --no-cache -t build-deps git libcap musl-dev gcc \
  && export GOPATH="/go" \
  && echo 'checkout sources ...' \
  && go get -u github.com/mholt/caddy \
  && go get -u github.com/caddyserver/builds \
  && cd "$GOPATH/src/github.com/mholt/caddy/caddy" \
  && echo 'patch run.go ...' \
  && sed -i 's/\(enableTelemetry = \)true/\1false/' caddymain/run.go \
  && echo 'patch build.go ...' \
  && sed -i 's/ldflags}/ldflags + " -linkmode external -extldflags -static"}/' build.go \
  && echo 'build binary ...' \
  && go run build.go \
  && setcap cap_net_bind_service=+ep caddy \
  && mv caddy / \
  && /caddy -version \
  && go get github.com/whyrusleeping/go-tftp \
  && cd "$GOPATH/src/github.com/whyrusleeping/go-tftp" \
  && echo 'build tftp server ...' \
  && CGO_ENABLED=0 go build \
  && setcap cap_net_bind_service=+ep go-tftp \
  && mv go-tftp /tftp

FROM scratch

COPY --from=0 /caddy /caddy
COPY --from=0 /tftp /tftp

ENV CADDY_ROOT      /srv
ENV CADDY_TLS_ROOT  /tls

WORKDIR $CADDY_ROOT

COPY ["index.html", "$CADDY_ROOT/"]
COPY ["caddyfile", "/"]

ENTRYPOINT ["/caddy"]
CMD ["-conf", "/caddyfile"]
