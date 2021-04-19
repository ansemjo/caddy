#!/usr/bin/env bash

export DOCKER_BUILDKIT=1
docker build -t docker.io/ansemjo/caddy:cgi   --target python .
docker build -t docker.io/ansemjo/caddy:plain --target plain  .
