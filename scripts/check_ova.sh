#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
python3 - "$ROOT" <<'PYCODE'
import sys, pathlib, re, html
root=pathlib.Path(sys.argv[1]); site=root/'ova/html'; content=(site/'index.html').read_text(encoding='utf8')
scenes=len(re.findall(r'<section\b[^>]*class="[^"]*\bslide\b',content))
print('Escenas:',scenes)
assert scenes==18, 'Se esperaban 18 escenas'
refs=set(re.findall(r'(?:src|href|data-src)="([^"]+)"',content))
missing=[v for v in refs if not v.startswith(('http:','https:','#','data:','mailto:','javascript:')) and not (site/html.unescape(v.split('?',1)[0])).is_file()]
assert not missing, f'Faltan recursos locales: {missing}'
assert (site/'assets/http_ipv6/HTTP_IPv6_LAN10_LAN40.pcap').is_file()
print('Recursos locales OK:',len(refs),'referencias')
PYCODE
