# Copyright (c) 2019 Anton Semjonov
# Licensed under the MIT License

# ---------- builders ----------

# golang base image and build requirements
FROM golang:1.23-alpine as builder
RUN apk add --no-cache git binutils musl-dev gcc \
  && { apk add --no-cache upx || true; }
WORKDIR /build

# copy main file and prepare to build
COPY main.go main.go
RUN go mod init caddy \
  && go get github.com/antlr/antlr4/runtime/Go/antlr \
  && go mod tidy

# build and strip the binary
RUN CGO_ENABLED=0 go build -ldflags '-s -w -extldflags "-static"' \
  && strip --strip-debug --strip-unneeded caddy \
  && { upx caddy || true; }

# ---------- runtimes ----------

# scratch with nothing but caddy
FROM scratch as plain

# copy binary and caddyfile
COPY --from=builder /build/caddy /caddy
COPY Caddyfile.plain /Caddyfile

# set entrypoint
WORKDIR /srv/www
ENTRYPOINT ["/caddy"]
CMD ["run", "--config", "/Caddyfile"]


# python base image for more flexible scripts
FROM python:3-alpine as python

# add useful tools for json/yaml parsing
RUN apk add --no-cache jq && pip install yq

# copy binary and prepare sample config
COPY --from=builder /build/caddy /caddy
COPY Caddyfile.cgi /Caddyfile

# set entrypoint
WORKDIR /srv/www
COPY hello.py hello.py
ENTRYPOINT ["/caddy"]
CMD ["run", "--config", "/Caddyfile"]
