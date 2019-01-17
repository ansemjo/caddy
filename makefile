RUNTIME := podman

.PHONY: build
build :
	$(RUNTIME) build -t ansemjo/caddy:proxy -f dockerfile --no-cache .

.PHONY: push
push :
	$(RUNTIME) push ansemjo/caddy:proxy
