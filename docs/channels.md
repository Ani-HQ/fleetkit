# Connect Discord, Telegram and WhatsApp

Each agent gets its own bot, so you can tell them apart. Set channels per agent in `fleet.yaml`:

```yaml
agents:
  - id: ops
    channels: [discord]
```

Tokens go in `.env`, named after the agent id: `DISCORD_TOKEN_OPS`, `TELEGRAM_TOKEN_ASSISTANT`. `./fleet setup` asks for them. After editing by hand, run `./fleet up`.

## Who can talk to your agents

Agents answer **you** in DMs. Set your IDs in `.env` (setup asks):

- `OWNER_DISCORD_ID`: Discord → Settings → Advanced → Developer Mode on. Right-click your name → Copy User ID.
- `OWNER_TELEGRAM_ID`: message [@userinfobot](https://t.me/userinfobot).
- `OWNER_WHATSAPP_NUMBER`: digits with country code, e.g. `447700900123`.

If you leave an ID blank, anyone who DMs the bot gets a pairing code. Approve it with `./fleet pair <channel> <code>`.

## Discord

1. Go to the [Discord Developer Portal](https://discord.com/developers/applications) → **New Application**. Name it after the agent.
2. **Bot** → **Reset Token** → copy it into `.env` as `DISCORD_TOKEN_<ID>`.
3. On the same page, turn on **Message Content Intent**.
4. **OAuth2 → URL Generator**: tick `bot` and `applications.commands`. Under bot permissions, tick Send Messages, Read Message History, Add Reactions, Attach Files, Use Slash Commands. Open the URL and add the bot to your server.
5. `./fleet up`. DM the bot, or mention it in a server channel.

Repeat for each Discord agent.

## Telegram

1. Message [@BotFather](https://t.me/BotFather) → `/newbot` → pick a name.
2. Copy the token into `.env` as `TELEGRAM_TOKEN_<ID>`.
3. `./fleet up`. Open your bot in Telegram and press Start.

To use a bot in a group, turn off privacy mode: BotFather → `/setprivacy` → Disable.

## WhatsApp

WhatsApp links to a real phone number, like WhatsApp Web. Use a spare number, not your personal one: the agent reads and replies to everything that number receives.

1. Set `channels: [whatsapp]` on one agent and `./fleet up`.
2. `./fleet whatsapp <agent-id>`. A QR code appears.
3. On the phone with the spare number: WhatsApp → Settings → Linked devices → Link a device → scan.
4. Message that number from your own phone.

You can give WhatsApp to one OpenClaw agent and one Hermes agent at most.

## Warden alerts (optional)

session-warden can send health alerts to Telegram. Create one more bot with BotFather, send it a message, then set `WARDEN_TELEGRAM_BOT_TOKEN` and `WARDEN_TELEGRAM_CHAT_ID` (your user ID) in `.env`.
