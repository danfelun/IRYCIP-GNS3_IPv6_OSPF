# Instalación y montaje en GNS3

## 1. Preparación

Instale Docker Engine, GNS3 y Wireshark en Linux. Verifique `docker ps` y que GNS3 utilice el Docker Engine local (no el socket de Docker Desktop por error). Configure los c7200 con una imagen IOS de procedencia legítima. Cisco IOS **no se suministra** en este proyecto.

Desde la raíz del repo:

```bash
chmod +x scripts/*.sh
./scripts/check_ova.sh
./scripts/build_images.sh
```

Se generan exactamente: `org-ipv6-cliente:1` y `org-ipv6-ova-web:3`. No es necesaria una imagen cliente GUI.

## 2. Topología de GNS3

Replicar la imagen de [topología](images/topologia_ipv6_laboratorio.png):

- **R1 g0/0 ↔ R2 g0/0**, prefijo `2001:DB8:ACAD:100::/64`.
- **R2 g2/0 ↔ R3 g0/0**, prefijo `2001:DB8:ACAD:200::/64`.
- **R1 g1/0 ↔ Switch1 ↔ VPCS PC1 y Raspbian opcional**, LAN10.
- **R2 g1/0 ↔ Switch2 ↔ PC-Cliente-2**, LAN20.
- **R3 g1/0 ↔ Switch3 ↔ PC-Cliente-3 y Server-WEB-IPv6-1**, LAN40.

Use *Ethernet switch* integrado GNS3. La numeración de adaptadores depende de los módulos c7200 cargados: **verifíquela en `show ip interface brief` y `show ipv6 interface brief` antes de pegar configuraciones**.

## 3. Routers y OSPFv3

En `gns3/ios/R1.txt`, `R2.txt`, `R3.txt` hay configuraciones de referencia para OSPFv3 proceso 10 y DHCPv6 Stateful en LAN10, LAN20 y LAN40. Aplicar gradualmente; IOS varía y puede necesitar adaptar comandos y nombres. No habilite pools de LAN ficticias: este escenario usa **10, 20 y 40**.

En cada router valide:

```text
show ipv6 interface brief
show ipv6 ospf neighbor
show ipv6 route ospf
show ipv6 dhcp binding
```

Las LAN deben anunciar RA para gateway y usar DHCPv6 Stateful para direcciones de clientes Linux. El anuncio RA `M=1` **no equivale** a una concesión. VPCS puede usar SLAAC o mostrar capacidades DHCPv6 limitadas; use cliente Linux para evidencia de Stateful.

## 4. Plantillas Docker

En GNS3: *Edit → Preferences → Docker containers → New*. Seleccione la imagen local correspondiente. Configure un adaptador Ethernet por nodo y asócielo al switch de la LAN. Para el cliente: consola **telnet** o comando de consola disponible. Para el servidor: `org-ipv6-ova-web:3`, un adaptador, puerto HTTP `80` en el contenedor. No es necesario publicar el puerto 80 en el host, porque la práctica se realiza sobre la topología IPv6 interna.

El servidor **debe tener capacidad NET_ADMIN** para configurar una dirección en `eth0`. Compruebe si la plantilla/versión GNS3 permite la capacidad; la imagen Docker **no puede concedérsela**. Si no es posible, asigne la IP manualmente mediante GNS3/`docker exec` y registre esa limitación. No ejecute GNS3 entero como root para resolver permisos.

## 5. Comprobación del servidor

Desde Ubuntu anfitrión:

```bash
docker ps --format 'table {{.ID}}\t{{.Names}}\t{{.Image}}'
# Sustituir ID_SERVIDOR por el ID real
docker logs ID_SERVIDOR --tail 60
docker exec -it ID_SERVIDOR bash
```

Dentro de Server-WEB:

```bash
ip -6 addr show dev eth0
ip -6 route
nginx -t
curl -g -6 --noproxy '*' -I 'http://[2001:db8:acad:40::10]/'
```

La dirección prevista es `2001:DB8:ACAD:40::10/64`. El gateway predeterminado se aprende por RA de R3; `ip -6 route` debe mostrarlo. Si en `docker logs` aparece `Operation not permitted`, revise `NET_ADMIN`. El script `configurar-ipv6.sh` espera y reintenta durante aproximadamente 2 minutos si GNS3 aún no conectó `eth0`; no se garantiza éxito si faltan permisos.

**Persistencia:** detener y volver a iniciar el nodo GNS3, localizar el contenedor nuevo y repetir las comprobaciones sin ejecutar `ip -6 addr add` manualmente.

## 6. Clientes Docker

En consola de cada cliente Linux (no VPCS):

```bash
ip -6 addr show dev eth0
ip -6 route
dhclient -6 -v -1 eth0
ip -6 addr show dev eth0
ping -6 -c 4 2001:db8:acad:40::10
curl -g -6 --noproxy '*' -I 'http://[2001:db8:acad:40::10]/'
```

LAN20 debe recibir una dirección del prefijo `2001:DB8:ACAD:20::/64`; LAN40, `2001:DB8:ACAD:40::/64`. `dhclient -6` requiere permisos de red y un pool DHCPv6 Stateful en el router correspondiente. La ruta predeterminada IPv6 proviene de **RA**, no del servidor DHCPv6. Si no hay dirección, inspeccione RA y bindings en R2/R3.

Reserve la dirección estática `::10` de Nginx frente a DHCPv6 de LAN40 para prevenir duplicados.

## 7. Cliente gráfico opcional

Consulte [GUIA_RASPBIAN.md](GUIA_RASPBIAN.md). Este recurso solo es necesario para visualizar el sitio en un escritorio con Chromium. Los estudiantes con equipos limitados pueden usar `curl` desde PC-Cliente-2 o PC-Cliente-3 y estudiar el PCAP incluido.

## 8. No incluido

No se empaqueta proyecto `.gns3project` final ni imagen IOS Cisco o VDI Raspbian. La topología se **reconstruye** manualmente a partir de la imagen y guías; verifique integridad y licenciamiento de cualquier recurso externo.
