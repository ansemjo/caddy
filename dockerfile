FROM alpine

ARG arch=amd64
ARG plugins=http.cgi
ARG telemetry=off
ARG license=personal

RUN apk add \
    --no-cache \
    gnupg \
    libcap \
    python2 \
    python3 \
  && cd /dev/shm \
  && mkdir gpghome \
  && gpg \
    --keyserver ha.pool.sks-keyservers.net \
    --recv-keys 65760C51EDEA2017CEA2CA15155B6D79CA56EA34 \
  && wget \
    --output-document caddy.tar.gz \
    --header "Accept: application/tar+bzip2" \
    "https://caddyserver.com/download/linux/$arch?plugins=$plugins&license=$license&telemetry=$telemetry" \
  && wget \
    --output-document caddy.tar.gz.asc \
    --header "Accept: text/plain" \
    "https://caddyserver.com/download/linux/$arch/signature?plugins=$plugins&license=$license&telemetry=$telemetry" \
  && gpg \
    --verify caddy.tar.gz.asc \
  && tar xz \
    -C /usr/local/bin \
    -f caddy.tar.gz \
    caddy \
  && caddy --version \
  && setcap \
    cap_net_bind_service=+ep \
    /usr/local/bin/caddy \
  && apk del \
    gnupg \
    libcap \
    2>/dev/null \
  && rm -rf ~/.gnupg \
  && mkdir -p /srv

WORKDIR /srv
USER nobody

ENTRYPOINT ["/usr/local/bin/caddy"]
CMD ["-conf", "/etc/caddyfile"]
