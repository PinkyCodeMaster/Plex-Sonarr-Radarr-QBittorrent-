# Deployment profiles (local CPU-only, GPU, or cloud)

## Local CPU-only (default)
- Use the provided Compose files as-is; qBittorrent remains pinned to the VPN container for privacy.
- If your host has no iGPU, you can leave the Plex `/dev/dri` mapping in place (it will simply be unused) or remove that line from `compose/media-stack.yml` for a cleaner config.
- Keep services behind Tailscale or your LAN; you can skip exposing 80/443 if you only need tailnet access.
- Store media/config/downloads on local disks as defined by `CONFIG_ROOT`, `MEDIA_ROOT`, and `DOWNLOADS_ROOT` in `.env`.

## Local with GPU acceleration (optional)
- Intel iGPU (Quick Sync): keep the `/dev/dri` device mapping in `compose/media-stack.yml`. Ensure your kernel/i915 drivers are enabled.
- NVIDIA: install `nvidia-container-toolkit`, then add to the Plex service in `compose/media-stack.yml`:
  - `runtime: nvidia`
  - environment: `NVIDIA_VISIBLE_DEVICES=all`, `NVIDIA_DRIVER_CAPABILITIES=compute,video,utility`
  - map your GPU device if needed (e.g., `/dev/nvidia0`).
- Plex hardware transcoding may require Plex Pass; the stack works in software mode without it.

## Cloud (AWS/Azure/GCP) with cost minimization
- Instance sizing: start small (e.g., 2 vCPU/4–8 GB RAM) and scale only if transcoding load demands it. Prefer CPU-only unless you need many simultaneous transcodes.
- Storage: use a single durable volume (EBS/Premium SSD/Persistent Disk) for `/data`; avoid many small volumes. Enable volume snapshots for backups.
- Networking:
  - Keep services on the internal `media` network; only expose 80/443 via Traefik/NPM. Keep Plex 32400 closed unless required.
  - Use Cloudflare DNS for free cert issuance; Let’s Encrypt is free.
  - Remember cloud egress fees; hosting closer to your viewers reduces cost.
- Spot/low-priority instances: acceptable for non-critical stacks; ensure you have backups (`scripts/backup.sh`) and can reattach volumes on restart.
- VPN: retain the Gluetun VPN container for qBittorrent even in cloud to prevent IP leakage.

## General cost tips
- Reuse existing hardware when possible; cloud is only needed for remote access or higher uptime.
- Avoid unnecessary GPU spend unless you truly need hardware transcodes.
- Schedule backups to cheap object storage with lifecycle rules; delete old archives automatically.
- Keep logs rotated to prevent storage bloat.

## Hosting options (starting points)
- Home lab (recommended for $0 infra): any Linux box with Docker; Tailscale for secure remote access.
- Hetzner CX/ARM or OVH/SYS budget servers: low-cost dedicated/VPS with predictable bandwidth pricing.
- AWS EC2: start with t4g/small instances; attach one EBS volume for `/data`. https://aws.amazon.com/ec2/
- Azure VMs: use B-series for burstable CPU and a single Premium SSD for `/data`. https://azure.microsoft.com/en-us/products/virtual-machines
- GCP Compute Engine: e2-standard/small with a single Persistent Disk for `/data`. https://cloud.google.com/compute
- DigitalOcean/Linode/Vultr: basic shared CPU droplet/instance with block storage for `/data` if needed. https://www.digitalocean.com/ || https://www.linode.com/ || https://www.vultr.com/

## Plex Pass (optional)
Plex hardware transcoding and some mobile features may require Plex Pass. The stack runs without it in software mode. More info: https://www.plex.tv/plex-pass/
