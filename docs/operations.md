# Operations

## Backups
- `scripts/backup.sh` captures configuration directories from `${CONFIG_ROOT}` into `${BACKUP_ROOT}` with timestamped archives.
- Consider storing archives in S3 or another bucket with lifecycle rules.

### Restore
1. Stop the stack: `./scripts/down.sh`.
2. Extract the desired archive to `${CONFIG_ROOT}` while preserving permissions.
3. Validate `.env` values and secrets before restart.
4. Start the stack: `./scripts/up.sh`.

### systemd timer example
`/etc/systemd/system/media-backup.service`:
```ini
[Unit]
Description=Media stack backup

[Service]
Type=oneshot
Environment=HOME=/root
WorkingDirectory=/opt/media-stack
ExecStart=/opt/media-stack/scripts/backup.sh
```

`/etc/systemd/system/media-backup.timer`:
```ini
[Unit]
Description=Run media stack backup daily

[Timer]
OnCalendar=daily
Persistent=true

[Install]
WantedBy=timers.target
```

Enable with:
```bash
sudo systemctl enable --now media-backup.timer
```

## API key rotation
- Rotate Sonarr, Radarr, and Prowlarr API keys via their UI, then update `.env` and restart the stack.
- For Traefik dashboard auth, regenerate `htpasswd` values and update `compose/traefik/dynamic.yml`.
- For VPN credentials, update `.env` and clear old configs under `${CONFIG_ROOT}/vpn`.

## Incident response
- If a container is compromised, revoke exposed credentials, rotate API keys, and rebuild images.
- Inspect logs and fail2ban bans to identify sources of repeated login attempts.
