#!/usr/bin/env bash

export DOCKER_BUILDKIT=1
docker build -t ghcr.io/ansemjo/caddy:cgi   --target python .
docker build -t ghcr.io/ansemjo/caddy:plain --target plain  .
