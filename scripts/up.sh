#!/usr/bin/env bash
set -euo pipefail

if [ ! -f .env ]; then
  echo "Missing .env file. Copy .env.example and update secrets." >&2
  exit 1
fi

docker compose -f compose/media-stack.yml -f compose/proxy.yml --env-file .env up -d
