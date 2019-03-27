# Copyright (c) 2019 Anton Semjonov
# Licensed under the MIT License

# ---------- build binary ----------

# golang base image
FROM golang:1.12-alpine as builder

# fetch sources
RUN apk add --no-cache git binutils \
  && go get -u github.com/mholt/caddy \
  && go get -u github.com/caddyserver/builds

# apply patches
RUN cd "$GOPATH/src/github.com/mholt/caddy/caddy" \
  && sed -i 's/\(enableTelemetry = \)true/\1false/wI' caddymain/run.go

# build binary
RUN cd "$GOPATH/src/github.com/mholt/caddy/caddy" \
  && go run build.go \
  && strip --strip-debug --strip-unneeded caddy \
  && mv caddy /caddy

# ---------- runtime image ----------

# start with empty image
FROM scratch

# metadata
LABEL maintainer="Anton Semjonov <anton@semjonov.de>"
LABEL license="MIT License"

# copy binary and prepare sample config
COPY --from=builder /caddy /caddy
COPY caddyfile /caddyfile

ENV CADDY_UPSTREAM  application:8000
ENV CADDY_TLS       /tls

# set entrypoint
ENTRYPOINT ["/caddy"]
CMD ["-conf", "/caddyfile"]
