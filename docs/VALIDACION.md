# Matriz de validaciones del laboratorio

| Prueba | Comando / acción | Esperado |
| --- | --- | --- |
| Imágenes | `docker image ls org-ipv6-cliente org-ipv6-ova-web` | `:1` y `:3` |
| OVA | `./scripts/check_ova.sh` | 18 escenas; imágenes enlazadas |
| Rutas | `show ipv6 ospf neighbor`, `show ipv6 route ospf` en routers | Vecinos Full y prefijos remotos |
| DHCPv6 | `dhclient -6 -v -1 eth0`; `show ipv6 dhcp binding` | Cliente Linux con concesión apropiada |
| Gateway | `ip -6 route` | Ruta por defecto vía RA link-local |
| Web estática | `ip -6 addr show dev eth0` servidor | `2001:db8:acad:40::10/64` |
| Servicio | `curl -6 -g -I 'http://[2001:db8:acad:40::10]/'` | HTTP 200 OK |
| HTTP entre sedes | `curl -6 --noproxy '*' 'http://[2001:db8:acad:40::10]/' -o /dev/null` | Descarga sin error desde LAN20 o LAN10 |
| Wireshark | `ipv6 && tcp.port == 80` | SYN, SYN-ACK, ACK, GET y HTTP 200 |
| Reinicio GNS3 | Detener/iniciar servidor y repetir `ip -6 addr` | Asignación automática si NET_ADMIN concedido |
| SCORM | Importación a Moodle y prueba de evaluación | Imágenes y nota comunicada correctamente |

## Captura ya incorporada

`ova/evidencias/HTTP_IPv6_LAN10_LAN40.pcap`, con evidencias E07 TCP handshake, E08 GET, E09 HTTP 200 y E10 Follow TCP Stream. Las imágenes están en `ova/html/assets/http_ipv6/`. Debido a que HTTP/80 no está cifrado, **revise el PCAP antes de compartir datos que no pertenezcan al ejercicio**.

## Diagnóstico

- **No hay IPv6 global:** cliente `dhclient -6 -v -1 eth0`; compruebe RA M/A/L y DHCPv6 en router; servidor revisar logs y permiso NET_ADMIN.
- **Hay ping pero no HTTP:** comprobar `nginx -t`, `ss -lnt`, `curl -I`, puerto 80 y `[::]:80`.
- **Chromium busca en DuckDuckGo:** use `http://[2001:db8:acad:40::10]/` literalmente, con corchetes.
- **GNS3 busca una imagen en Docker Hub:** la plantilla usa una etiqueta inexistente localmente; reconstruya la imagen y actualice **también el nodo** (no solo la plantilla).
- **GNS3 no permite `docker network connect`:** no fuerce interfaces Docker ajenas al manejo de namespaces de GNS3.
