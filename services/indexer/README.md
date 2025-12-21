# Indexer (Prowlarr) Guidance

## Configuration
- Categories: map **TV** to 5000 and **Movies** to 2000 to align with Sonarr/Radarr defaults.
- Indexers: add at least two reputable trackers and enable RSS + search.
- API key: set `PROWLARR_API_KEY` in `.env` and configure Sonarr/Radarr with the same key.
- URL: `https://prowlarr.${TRAEFIK_DOMAIN}` through Traefik or `http://localhost:${PROWLARR_PORT}` locally.

## FlareSolverr helper
- For Cloudflare-protected indexers, configure the FlareSolverr proxy at `http://flaresolverr:8191` in Prowlarr's *Proxy* settings.
- Consider routing Prowlarr traffic through VPN (`network_mode: service:vpn`) if permitted by your provider and indexer rules.

## Safety and privacy
- Respect DMCA and content policies; remove problematic indexers quickly.
- Prefer IP filtering at the host firewall to limit who can reach the proxy ports.
- Use DNS-over-HTTPS/TLS on the host to prevent DNS leakage.
