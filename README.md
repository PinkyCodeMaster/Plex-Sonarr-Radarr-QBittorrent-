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
3. Start the stack with Traefik: `scripts/up.sh` (or swap Traefik for NPM with `-f compose/npm-proxy.yml`).
4. Access services through your proxy hostnames (e.g., `sonarr.${TRAEFIK_DOMAIN}`) or Plex on `:32400`.

## Notes
- qBittorrent is pinned to the VPN container via `network_mode: service:vpn`.
- Secrets live in `.env` or secret stores; never commit real values.
