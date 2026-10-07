# fleetkit

Your own AI agent fleet on one server. It runs on the Claude and ChatGPT subscriptions you already pay for, with no API keys, and you talk to it on Discord, Telegram or WhatsApp.

```bash
curl -fsSL https://raw.githubusercontent.com/Ani-HQ/fleetkit/main/install.sh | bash
cd ~/fleetkit
./fleet setup          # a few questions: name, timezone, agents, chat bots
./fleet up             # start everything
./fleet login claude   # and/or: ./fleet login chatgpt
```

DM your bot. That's it.

## What you get

| Piece | What it does |
| --- | --- |
| [OpenClaw](https://github.com/openclaw/openclaw) | Gateway for your main agents. Starts with **ops** and **builder**. |
| [Hermes Agent](https://github.com/NousResearch/hermes-agent) | A second harness. Starts with **assistant**. |
| [engram](https://github.com/Ani-HQ/engram) + gbrain | Shared long-term memory every agent reads and writes, over MCP. |
| [session-warden](https://github.com/Ani-HQ/session-warden) | Keeps agents healthy: rotates bloated sessions, guards usage limits, nightly reflection, weekly reviews. |
| Fleet board | A live page showing what each agent is doing. |

The agents are generic starters. Rename them, change their roles, or add more in `fleet.yaml`, then run `./fleet up` again.

## What you need

- A Linux server with **4 GB RAM** and 2 vCPUs (Ubuntu 22.04+ or Debian 12+). Any cloud works. See [docs/deploy.md](docs/deploy.md).
- **Claude Pro/Max** or **ChatGPT Plus/Pro** (or both). See [docs/subscriptions.md](docs/subscriptions.md).
- A bot for each agent on Discord or Telegram, or a spare WhatsApp number. See [docs/channels.md](docs/channels.md).

**No API keys.** Every model call goes through your subscription login, the same way the Claude and Codex apps do. If you have both subscriptions, agents switch to the other one when they hit a usage limit.

## Can I deploy it to Vercel?

No. Vercel runs short-lived functions. A fleet needs processes that stay up all the time, a disk that persists between restarts, and scheduled jobs. Use any VPS or cloud VM (from about $5/month). Railway support is planned.

## Everyday commands

```
./fleet status            what's running
./fleet logs openclaw     follow logs (openclaw, hermes, engram, init)
./fleet ui                open the dashboards (over an SSH tunnel)
./fleet pair discord ABC  approve someone who messaged an agent
./fleet whatsapp ops      pair WhatsApp by QR code
./fleet backup            snapshot config, logins, sessions and memory
./fleet update            pull the latest fleetkit and restart
./fleet openclaw <args>   OpenClaw CLI inside the fleet
./fleet hermes <id> <args> Hermes CLI for one agent
```

## How it fits together

```
fleet.yaml + .env
      │
      ▼
   init ──────────── renders OpenClaw config, Hermes profiles, warden schedule
      │
      ├── openclaw   gateway + session-warden (cron) + fleet board   :18789 :8090
      ├── hermes     gateway + dashboard                              :9119
      └── engram     memory server (Postgres + pgvector)              :8080
```

- `fleet.yaml` is the only file you edit. `init` turns it into native config every time you run `./fleet up`.
- Files the agents write themselves (memory notes, personas after first boot) are never overwritten.
- All ports are bound to `127.0.0.1`. Reach the dashboards over SSH. See [docs/security.md](docs/security.md).
- Data lives in Docker volumes. `./fleet backup` saves all of it.

## Docs

- [Deploy to a cloud](docs/deploy.md)
- [Connect subscriptions](docs/subscriptions.md)
- [Connect Discord, Telegram, WhatsApp](docs/channels.md)
- [Security](docs/security.md)
- [Upgrading and backups](docs/upgrading.md)

## License

MIT
