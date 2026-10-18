FROM nginx:stable-bookworm

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       bash iproute2 iputils-ping curl procps dnsutils ca-certificates \
    && rm -rf /var/lib/apt/lists/*

COPY docker/servidor-ova-web/nginx-default.conf /etc/nginx/conf.d/default.conf
COPY ova/html/index.html /usr/share/nginx/html/index.html
COPY ova/html/assets/ /usr/share/nginx/html/assets/
COPY docker/servidor-ova-web/scripts/configurar-ipv6.sh /usr/local/bin/configurar-ipv6.sh
COPY docker/servidor-ova-web/scripts/iniciar-servidor.sh /usr/local/bin/iniciar-servidor.sh
RUN chmod 755 /usr/local/bin/configurar-ipv6.sh /usr/local/bin/iniciar-servidor.sh

EXPOSE 80/tcp
HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 \
 CMD curl --noproxy '*' -fsS http://127.0.0.1/ -o /dev/null || exit 1

ENTRYPOINT ["/usr/local/bin/iniciar-servidor.sh"]
