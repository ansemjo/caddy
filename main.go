package main

import (
  cmd "github.com/caddyserver/caddy/v2/cmd"

  _ "github.com/caddyserver/caddy/v2/modules/standard"
	_ "github.com/aksdb/caddy-cgi/v2"
)

func main() {
  cmd.Main()
}
