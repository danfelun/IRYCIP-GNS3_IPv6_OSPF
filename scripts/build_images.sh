#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
docker build -t org-ipv6-cliente:1 -f docker/cliente-linux/Dockerfile docker/cliente-linux
docker build -t org-ipv6-ova-web:3 -f docker/servidor-ova-web/Dockerfile .
docker image ls org-ipv6-cliente org-ipv6-ova-web
