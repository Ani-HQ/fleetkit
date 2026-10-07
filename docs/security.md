# Security

Agents can run commands and read files inside their containers, and they act with your subscription logins. Treat the server like a laptop you've left logged in.

## Defaults

- **No public ports.** Every dashboard and API is bound to `127.0.0.1`. Use `./fleet ui` for the SSH tunnel command.
- **DMs are owner-only.** Agents only answer the IDs in `.env`. Anyone else needs a pairing code you approve.
- **Generated secrets.** `./fleet setup` creates the gateway token, dashboard password and database password with `openssl rand`. `.env` is `chmod 600` and gitignored.
- **Memory tokens.** Each service gets its own engram token, minted on first boot and stored only in the `fleet-secrets` volume.
- **Non-root agents.** OpenClaw and Hermes run as uid 1000.

## Recommendations

- Use SSH keys, turn off password login, and enable a firewall that only allows SSH (`ufw allow OpenSSH && ufw enable`).
- Give WhatsApp a spare number. The agent sees everything sent to it.
- In Discord, add bots to a private server or private channels. Server channels are open to everyone in them by default.
- Pin `FLEETKIT_VERSION` to a release in `.env` and update on purpose.
- Run `./fleet backup` before updates, and copy `backups/` off the server. Backups contain your logins: store them like passwords.

## If you want public dashboards

Put a reverse proxy with authentication in front (Caddy + basic auth, Cloudflare Access, or Tailscale). Don't change the port bindings to `0.0.0.0`.

## Reporting issues

Open a private security advisory on the GitHub repo.
