#!/usr/bin/env bash
set -e
# GNS3 puede incorporar eth0 despues de iniciar el proceso del contenedor.
# La configuracion IPv6 se ejecuta en paralelo para no detener Nginx.
/usr/local/bin/configurar-ipv6.sh &
echo "[OVA] Iniciando Nginx; sitio OVA v5 (18 escenas)."
exec nginx -g 'daemon off;'
