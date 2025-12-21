#!/usr/bin/env bash
set -euo pipefail

docker compose -f compose/media-stack.yml -f compose/proxy.yml --env-file .env down
