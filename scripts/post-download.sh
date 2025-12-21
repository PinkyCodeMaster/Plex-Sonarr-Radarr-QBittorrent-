#!/usr/bin/env bash
# Args from qBittorrent: %L (category), %N (torrent name), %R (root path), %F (content path)
set -euo pipefail

CATEGORY=${1:-unsorted}
NAME=${2:-unknown}
ROOT_PATH=${3:-${DOWNLOADS_ROOT:-/data/downloads}}
CONTENT_PATH=${4:-""}

PUID=${PUID:-1000}
PGID=${PGID:-1000}
MEDIA_ROOT=${MEDIA_ROOT:-/data/media}
DOWNLOADS_ROOT=${DOWNLOADS_ROOT:-/data/downloads}
LOG_FILE=${LOG_FILE:-/var/log/qbittorrent-post-download.log}

umask 002

mkdir -p "$(dirname "$LOG_FILE")"
exec >>"$LOG_FILE" 2>&1

echo "[\"$(date -Is)\"] handling $NAME ($CATEGORY)"

TARGET_DIR="$MEDIA_ROOT/unsorted"
case "$CATEGORY" in
  tv|TV)
    TARGET_DIR="$MEDIA_ROOT/tv"
    ;;
  movies|movie|Movies)
    TARGET_DIR="$MEDIA_ROOT/movies"
    ;;
  *)
    ;; # leave unsorted
esac

SOURCE_PATH="$DOWNLOADS_ROOT/$CONTENT_PATH"
mkdir -p "$TARGET_DIR"

rsync -avh --remove-source-files "$SOURCE_PATH" "$TARGET_DIR" || {
  echo "[!] rsync failed for $SOURCE_PATH";
  exit 1;
}

find "$TARGET_DIR" -type d -exec chmod 2775 {} +
find "$TARGET_DIR" -type f -exec chmod 0664 {} +
chown -R "$PUID:$PGID" "$TARGET_DIR"

echo "[+] Completed move for $NAME to $TARGET_DIR"
