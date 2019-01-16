# Copyright 2018 Anton Semjonov
# Licensed under the MIT License

FROM golang:1.11-alpine as builder

LABEL maintainer="Anton Semjonov <anton@semjonov.de>"
LABEL license="MIT License"

RUN echo 'checkout sources ...' \
  && apk add --no-cache git \
  && go get -u github.com/mholt/caddy \
  && go get -u github.com/caddyserver/builds

RUN cd "$GOPATH/src/github.com/mholt/caddy/caddy" \
  && echo 'patch run.go ...' \
  && sed -i 's/\(enableTelemetry = \)true/\1false/I' caddymain/run.go \
  && echo 'build binary ...' \
  && go run build.go \
  && mv caddy /usr/local/bin/

FROM alpine:latest

COPY --from=builder /usr/local/bin/caddy /usr/local/bin/caddy
COPY ["caddyfile", "/"]
ENV CADDY_UPSTREAM  application:8000
ENV CADDY_TLS       /run/tls

ENTRYPOINT ["/usr/local/bin/caddy"]
CMD ["-conf", "/caddyfile"]
