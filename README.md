# Plex / Sonarr / Radarr / qBittorrent Stack

Infrastructure-as-code and container orchestration scaffolding for a self-hosted media stack with VPN routing and hardened defaults.

## Layout
- `compose/`: Docker Compose bundles (`media-stack.yml` and `proxy.yml`) plus Traefik config.
- `infra/`: Terraform (cloud primitives) and Ansible (host config) baselines.
- `services/`: Service-specific notes (e.g., `services/indexer`).
- `docs/`: Security, workflows, and operations guidance.
- `scripts/`: Bootstrap, lifecycle, validation, backup, and post-download helpers.
- `compose/npm-proxy.yml`: Optional Nginx Proxy Manager bundle (for Cloudflare/NPM users).

## Quickstart
1. Copy `.env.example` to `.env` and fill in credentials/placeholders.
2. Install Docker and Compose via `scripts/bootstrap.sh`.
3. Choose your proxy (see below), then start the stack:
   - Traefik (default): `scripts/up.sh`
   - Nginx Proxy Manager (Cloudflare-friendly): `docker compose -f compose/media-stack.yml -f compose/npm-proxy.yml --env-file .env up -d`
4. Access services through your proxy hostnames (e.g., `sonarr.${TRAEFIK_DOMAIN}`) or Plex on `:32400`.
5. Run `scripts/validate.sh` to confirm `.env` completeness and compose config.

## Proxy choice
- **Traefik** (compose/proxy.yml): automatic TLS via Let’s Encrypt; add your htpasswd hash in `compose/traefik/dynamic.yml`. If using Cloudflare, you can switch to DNS-01 with `CLOUDFLARE_API_TOKEN` (see `docs/proxy.md`).
- **Nginx Proxy Manager** (compose/npm-proxy.yml): web UI on port 81, works well with Cloudflare HTTP-01 or DNS; configure proxy hosts pointing at service names on the `edge` network. See `docs/proxy.md` for steps.
- **Tailscale users**: You can restrict admin surfaces to tailnet IPs via Traefik middleware or NPM access lists; you may also keep 80/443 closed publicly and reach services over Tailscale.

## Notes
- qBittorrent is pinned to the VPN container via `network_mode: service:vpn`.
- Secrets live in `.env` or secret stores; never commit real values.
