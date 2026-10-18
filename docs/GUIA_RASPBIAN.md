# Cliente gráfico opcional: Raspbian en VirtualBox

La modalidad **completa** puede añadir Raspbian-1 a Switch1/LAN10. La imagen preconfigurada de terceros se obtiene de [OSBoxes Raspbian](https://www.osboxes.org/raspbian/). Revise su antigüedad, condiciones y hash de descarga; no se redistribuye aquí.

1. Instale VirtualBox (compatible con su equipo) y GNS3.
2. Descargue la imagen de Raspbian/VDI desde OSBoxes y compruebe su checksum publicado.
3. Cree una VM en VirtualBox y utilice el disco VDI descargado; configure memoria según su disponibilidad y deje un adaptador de red para GNS3.
4. En GNS3, *Edit → Preferences → VirtualBox VMs → New*, agregue la VM creada. Conecte su Ethernet al Switch1. No utilice simultáneamente el adaptador en NAT/bridge hacia redes externas para el ejercicio IPv6 sin necesidad.
5. Inicie la VM desde GNS3. En terminal valide `ip -6 addr show dev eth0` e `ip -6 route` (la interfaz podría tener otro nombre). Confirme dirección del prefijo LAN10.
6. Realice `ping -6 -c 4 2001:db8:acad:40::10`. En Chromium abra **`http://[2001:db8:acad:40::10]/`** (corchetes obligatorios para literal IPv6 en URL).
7. Opcionalmente use Wireshark en enlace de GNS3 para estudiar `ipv6 && tcp.port == 80` y `http.request`/`http.response`.

**Seguridad:** la VM de OSBoxes es una distribución antigua y preconfigurada. Manténgala aislada, cambie claves predeterminadas y no la use como estación de trabajo personal.

**Alternativa ligera:** no instalar VirtualBox ni Raspbian; validar con `curl` en contenedores y estudiar `ova/evidencias/HTTP_IPv6_LAN10_LAN40.pcap` e imágenes de `ova/html/assets/http_ipv6/`.
