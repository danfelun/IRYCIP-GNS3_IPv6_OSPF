# Publicación Moodle: SCORM y estado H5P

## Paquete principal: SCORM 1.2 (18 escenas)

Archivo: `ova/scorm/ORIGEN_IPV6_SCORM12_18_ESCENAS.zip`. Fue regenerado **desde `ova/html/` v5**, no se recicló el SCORM v4. Incluye manifiesto `imsmanifest.xml` en la raíz del ZIP, HTML, imágenes y PCAP. Para volver a generarlo: `python3 scripts/build_scorm.py`.

En Moodle: activar edición → **Añadir actividad o recurso → Paquete SCORM** → cargar el ZIP → definir visualización, intentos, evaluación, calificación y disponibilidad → guardar. Verifique la navegación hasta la escena 18, imágenes en escenas 5, 7, 10 y 18, ampliación de capturas, descarga PCAP y reporte del puntaje de los seis desafíos originales. **La compatibilidad con SCORM en la instalación institucional debe comprobarse en Moodle**, especialmente la comunicación con la API de calificaciones.

## Sobre H5P

El antiguo archivo H5P disponible corresponde a una **beta experimental**, y **no está acreditado como exportación completa equivalente** a las 18 escenas. No se incluye ni anuncia como paquete listo para subir a Moodle. Crear un `.h5p` completo requiere adaptar las interacciones y comprobar el paquete en el tipo de contenido H5P instalado en Moodle; renombrar el ZIP SCORM a `.h5p` no funciona. Si se necesita H5P nativo, se debe planificar como un entregable distinto.

## Versión HTML autónoma

Abra `ova/html/index.html` desde un navegador. También se incluye en la imagen Nginx. Para una prueba local sin GNS3 puede ejecutar `python3 -m http.server 8080 -d ova/html` y abrir `http://localhost:8080/` (esta prueba local no valida OSPFv3).
