# Media Automation Workflows

## Pipeline overview
1. Indexer (Prowlarr) provides search results to Sonarr/Radarr.
2. Sonarr/Radarr send torrents to qBittorrent via its Web API.
3. qBittorrent downloads to `${DOWNLOADS_ROOT}` and triggers a post-download hook.
4. Post-download script sets ownership/permissions, moves completed files into `${MEDIA_ROOT}`, and signals Sonarr/Radarr to import.
5. Plex library scans pick up new media (via webhook or scheduled task).

## Post-download script
A sample hook lives at `scripts/post-download.sh`. Wire it to qBittorrent via **Tools → Options → Downloads → Run external program on torrent finished**:
```
/scripts/post-download.sh "%L" "%N" "%R" "%F"
```

The script:
- Enforces `umask 002` and `setgid` on target directories.
- Moves files from `${DOWNLOADS_ROOT}/completed` into `${MEDIA_ROOT}/tv` or `${MEDIA_ROOT}/movies` based on labels.
- Adjusts ownership to `${PUID}:${PGID}` and logs actions.

## Library refresh
- Sonarr/Radarr can be configured to rescan folders after import; alternatively, use Plex webhooks.
- Plex can be refreshed via its HTTP API. Example:
```bash
curl -X POST "http://localhost:32400/library/sections/1/refresh" \
  -H "X-Plex-Token=${PLEX_TOKEN}"
```

## Backup scheduling
- Use cron or systemd timers to run `scripts/backup.sh` daily and before upgrades.
- Suggested cron entry (daily at 03:00):
```
0 3 * * * /usr/local/bin/backup-media.sh >> /var/log/media-backup.log 2>&1
```
- Example systemd timer/service units are referenced in `docs/operations.md`.
