# Security Hardening

## Network and access controls
- Keep application containers on the internal `media` network; only Traefik and VPN endpoints expose ports to the host.
- Limit inbound access to TCP 80/443 (Traefik) and Plex's direct stream port 32400 when required.
- Prefer DNS-over-HTTPS or DNS-over-TLS on the host (e.g., via systemd-resolved or cloudflared) to reduce ISP visibility.

### Example firewall rules (ufw)
```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp comment "SSH"
sudo ufw allow 80,443/tcp comment "Traefik"
sudo ufw allow 32400/tcp comment "Plex"
sudo ufw enable
```

### Example fail2ban jail (Traefik access logs)
`/etc/fail2ban/jail.d/traefik.conf`:
```ini
[traefik-auth]
enabled = true
port    = 80,443
filter  = traefik-auth
logpath = /var/log/traefik/access.log
maxretry = 5
bantime = 3600
```

`/etc/fail2ban/filter.d/traefik-auth.conf`:
```ini
[Definition]
failregex = ^<HOST> .+ \"(GET|POST).+ 401 .+
```

## Secrets handling
- Store secrets in `.env` or Docker/Ansible/Terraform secret managers; never commit real values.
- Use Ansible Vault for SSH keys or API tokens and Terraform remote state with encryption.
- Rotate API keys regularly; see `docs/operations.md` for rotation guidance.

## VPN and privacy
- Keep qBittorrent bound to the `vpn` service (`network_mode: service:vpn`) and validate the VPN healthcheck before downloads resume.
- For indexers behind Cloudflare, route traffic through FlareSolverr and consider proxying through VPN if allowed by provider.
- Enforce `umask` and `setgid` on download directories to avoid permission leaks.
- If you use Tailscale, prefer limiting admin surfaces (Sonarr/Radarr/NPM/Traefik) to Tailscale IPs or add proxy-layer allowlists so only your tailnet can reach them.
