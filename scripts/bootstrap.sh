#!/usr/bin/env bash
set -euo pipefail

if ! command -v docker >/dev/null 2>&1; then
  echo "[+] Installing Docker and dependencies"
  sudo apt-get update
  sudo apt-get install -y docker.io docker-compose-plugin wireguard
  sudo systemctl enable --now docker
else
  echo "[+] Docker already installed"
fi

echo "[+] Creating data directories"
sudo mkdir -p /data/{config,media,downloads,backups}
sudo chown ${PUID:-1000}:${PGID:-1000} /data/{config,media,downloads,backups}

echo "[+] Pulling images"
docker compose -f compose/media-stack.yml -f compose/proxy.yml --env-file .env pull

echo "[+] Bootstrap completed"
