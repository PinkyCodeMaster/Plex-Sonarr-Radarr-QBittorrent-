#!/usr/bin/env bash
set -euo pipefail

BACKUP_ROOT=${BACKUP_ROOT:-/data/backups}
CONFIG_ROOT=${CONFIG_ROOT:-/data/config}
STAMP=$(date +%Y%m%d-%H%M%S)
DEST="$BACKUP_ROOT/backup-$STAMP.tar.gz"

mkdir -p "$BACKUP_ROOT"

echo "[+] Backing up configs from $CONFIG_ROOT"
tar -czf "$DEST" -C "$CONFIG_ROOT" .

echo "[+] Backup written to $DEST"
