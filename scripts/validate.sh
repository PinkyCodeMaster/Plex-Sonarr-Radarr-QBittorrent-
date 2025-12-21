#!/usr/bin/env bash
set -euo pipefail

if [ ! -f .env ]; then
  echo "Missing .env file. Copy .env.example and set values." >&2
  exit 1
fi

missing=()
while IFS='=' read -r key _; do
  [[ -z "$key" || "$key" =~ ^# ]] && continue
  if ! grep -q "^${key}=" .env; then
    missing+=("$key")
  fi
done < .env.example

if [ ${#missing[@]} -gt 0 ]; then
  echo "[!] Missing keys in .env: ${missing[*]}" >&2
  exit 1
fi

echo "[+] docker compose config (media/proxy)"
docker compose -f compose/media-stack.yml -f compose/proxy.yml --env-file .env config >/dev/null

echo "[+] Checking service health endpoints"
for port in 32400 ${PROWLARR_PORT:-9696}; do
  if nc -z localhost "$port" 2>/dev/null; then
    echo " - Port $port reachable"
  else
    echo " - Port $port not reachable (if stack down, start it first)"
  fi
done

echo "[+] Validation complete"
