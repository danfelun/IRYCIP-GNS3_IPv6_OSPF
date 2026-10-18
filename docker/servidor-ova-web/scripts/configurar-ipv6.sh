#!/usr/bin/env bash
set -u
ADDR="${OVA_IPV6_ADDR:-2001:db8:acad:40::10/64}"
IFACE="${OVA_IPV6_IFACE:-eth0}"
ATTEMPTS="${OVA_IPV6_ATTEMPTS:-60}"

for ((n=1; n<=ATTEMPTS; n++)); do
  if ip link show dev "$IFACE" >/dev/null 2>&1; then
    if ip -6 addr show dev "$IFACE" | grep -Fq "inet6 ${ADDR} "; then
      echo "[OVA IPv6] Direccion ${ADDR} ya presente en ${IFACE}."
      exit 0
    fi
    if output=$(ip -6 addr replace "$ADDR" dev "$IFACE" 2>&1); then
      echo "[OVA IPv6] Direccion asignada: ${ADDR} dev ${IFACE}."
      ip -6 addr show dev "$IFACE"
      ip -6 route show
      echo "[OVA IPv6] La ruta predeterminada se aprende de RA del router R3."
      exit 0
    fi
    echo "[OVA IPv6] Intento $n/$ATTEMPTS: no fue posible asignar $ADDR ($output)."
    if [[ "$output" == *"Operation not permitted"* ]]; then
      echo "[OVA IPv6] Se requiere NET_ADMIN en la plantilla Docker de GNS3."
      exit 1
    fi
  else
    echo "[OVA IPv6] Intento $n/$ATTEMPTS: esperando interfaz ${IFACE} de GNS3."
  fi
  sleep 2
done

echo "[OVA IPv6] ERROR: no se pudo configurar ${ADDR} tras ${ATTEMPTS} intentos."
exit 1
