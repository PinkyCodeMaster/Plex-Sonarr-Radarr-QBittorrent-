# Proxy options (Traefik or Nginx Proxy Manager)

## Using Traefik (default in `compose/proxy.yml`)
- Set `TRAEFIK_DOMAIN`, `TRAEFIK_EMAIL`, and `TRAEFIK_DASHBOARD_HOST` in `.env`.
- Cloudflare users: either use the existing HTTP challenge (orange-cloud off) or switch to DNS challenge by adding `--certificatesresolvers.letsencrypt.acme.dnschallenge=true` and the Cloudflare DNS environment vars (`CLOUDFLARE_API_TOKEN`).
- Add an htpasswd hash to `compose/traefik/dynamic.yml` to protect the dashboard.

## Using Nginx Proxy Manager (NPM) with Cloudflare
- Compose file: `compose/npm-proxy.yml` binds ports 80/443 and shares the `edge` network with the media containers.
- Steps:
  1. Point Cloudflare DNS A/AAAA records for your media subdomains at your server. Disable orange-cloud proxy during initial issuance if using HTTP challenge.
  2. Start the media stack first to create the shared `edge`/`media` networks: `docker compose -f compose/media-stack.yml --env-file .env up -d`.
  3. Start NPM: `docker compose -f compose/media-stack.yml -f compose/npm-proxy.yml --env-file .env up -d npm` (or omit if already running).
  3. Login to NPM UI (default admin email from `.env`): `https://<server>:81` (set a strong password and enable 2FA).
  4. Create Proxy Hosts for `plex`, `sonarr`, `radarr`, `prowlarr` pointing to the container on the `edge` network:
     - Forward hostname: service name (e.g., `sonarr`), scheme `http`, port (8989 Sonarr, 7878 Radarr, 9696 Prowlarr, 32400 Plex).
     - Access Lists / Auth: optional; recommended for admin surfaces.
     - SSL: Request a new cert via Let’s Encrypt; supply email; enable HTTP/2, HSTS, and Force SSL.
  5. Re-enable Cloudflare orange-cloud after cert issuance if desired.

## Tailscale considerations
- You can restrict admin access to Tailscale IPs by adding NPM access lists or Traefik middleware rules that only allow `100.x.y.z/10` addresses.
- Expose fewer host ports when using Tailscale; you may keep 80/443 closed publicly and access services via Tailscale IP + proxy.
- If using exit nodes, ensure the VPN container still routes torrent traffic through Gluetun; do not leak qBittorrent outside VPN.
