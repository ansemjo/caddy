RUNTIME := podman

.PHONY: build
build :
	$(RUNTIME) build -t ansemjo/caddy:proxy .

.PHONY: push
push :
	$(RUNTIME) push ansemjo/caddy:proxy
