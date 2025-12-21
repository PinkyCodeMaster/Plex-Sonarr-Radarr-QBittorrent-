# Contributing

- Never commit real secrets, API keys, credentials, or certificates. Use placeholders and load them from `.env` files or Docker/Ansible/Terraform secret managers.
- Keep sample values in `.env.example` only and scrub outputs/logs that might contain secrets before sharing.
- Prefer Docker secrets, Ansible vault, or Terraform-managed secret stores for sensitive data at rest.
- Rotate credentials regularly and document any secret touchpoints in `docs/operations.md`.
