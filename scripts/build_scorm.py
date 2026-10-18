#!/usr/bin/env python3
"""Produce SCORM 1.2 directly from the versioned HTML v5. No stale v4 assets."""
from pathlib import Path
import zipfile, xml.etree.ElementTree as ET
from xml.sax.saxutils import escape
root=Path(__file__).resolve().parent.parent
site=root/'ova/html'
files=sorted(p for p in site.rglob('*') if p.is_file())
assert (site/'index.html') in files
manifest='<?xml version="1.0" encoding="UTF-8"?>\n<manifest identifier="IRYCIP_IPV6_OSPF_18_SCENES" version="1.0" xmlns="http://www.imsproject.org/xsd/imscp_rootv1p1p2" xmlns:adlcp="http://www.adlnet.org/xsd/adlcp_rootv1p2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.imsproject.org/xsd/imscp_rootv1p1p2 imscp_rootv1p1p2.xsd http://www.adlnet.org/xsd/adlcp_rootv1p2 adlcp_rootv1p2.xsd">\n <metadata><schema>ADL SCORM</schema><schemaversion>1.2</schemaversion></metadata>\n <organizations default="ORG1"><organization identifier="ORG1"><title>ORIGEN - IPv6 bajo investigación · 18 escenas</title><item identifier="ITEM1" identifierref="RES1"><title>IPv6, DHCPv6, OSPFv3 y HTTP: análisis de evidencias</title></item></organization></organizations>\n <resources><resource identifier="RES1" type="webcontent" adlcp:scormtype="sco" href="index.html">\n' + ''.join(' <file href="'+escape(p.relative_to(site).as_posix(), {'"':'&quot;'})+'"/>\n' for p in files) + ' </resource></resources>\n</manifest>\n'
ET.fromstring(manifest)
target=root/'ova/scorm/ORIGEN_IPV6_SCORM12_18_ESCENAS.zip'
with zipfile.ZipFile(target,'w',zipfile.ZIP_DEFLATED,compresslevel=8) as z:
 z.writestr('imsmanifest.xml',manifest)
 for p in files:z.write(p,p.relative_to(site).as_posix())
print('SCORM generado:',target)
