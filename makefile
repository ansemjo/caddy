.PHONY: devel run build

devel: build run

run:
	docker run --rm -it \
		-v $(PWD)/caddyfile:/etc/caddyfile \
		-v /root/mirror/compose/htdocs:/srv \
		-p 80:80 \
		--init \
		caddy

build:
	docker build -t caddy .
