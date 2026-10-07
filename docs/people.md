# Several people, one fleet

A fleet can be used by more than one person. Everyone you list shares the
agents, the memory and the subscriptions you connected. Anyone can also connect
their own ChatGPT, and their new chats are billed to that instead.

## Add people

In `fleet.yaml`:

```yaml
people:
  - id: owner
    name: Sam
    discord: "111111111111111111"

  - id: ria
    name: Ria
    discord: "222222222222222222"
    telegram: "333333333"
```

IDs are how you find them:

- Discord: Settings → Advanced → Developer Mode, then right-click the person → Copy User ID.
- Telegram: they message [@userinfobot](https://t.me/userinfobot).
- WhatsApp: their number, digits with country code.

Then `./fleet up`. Agents answer only these people in DMs. In a Discord server,
everyone in the channel can talk to the agent.

Leave `people` out and the fleet stays single-person, answering only the owner
set during setup.

## Let someone use their own ChatGPT

This needs Tailscale, because the dashboard has to know which person a browser
belongs to.

1. Install Tailscale on the server's behalf: create a reusable auth key at
   `https://login.tailscale.com/admin/settings/keys` and set `TS_AUTHKEY` in
   `.env`. Each person installs Tailscale on their own device and joins the
   same tailnet.
2. `./fleet up`. The fleet joins the tailnet and serves the dashboard over
   Tailscale at `https://<machine>.<tailnet>.ts.net`. The direct
   `localhost:18789` port is turned off in this mode, because only the
   Tailscale address can tell people apart.
3. The person opens that address from their own device. Tailscale tells the
   fleet who they are.
4. In the dashboard: **Settings → Profile → Connected accounts → Add account →
   OpenAI → device code**. They approve it with their own ChatGPT login.

Their new chats then prefer their account. Chats already running stay on the
fleet's subscription, and anyone who never connects an account keeps using the
fleet's. If their account runs out of usage, the chat falls back to the fleet's
subscription for that turn.

## What is shared and what is not

| | Fleet's subscription | A person's own ChatGPT |
| --- | --- | --- |
| Who connects it | you, with `./fleet login` | each person, in the dashboard |
| Who it bills | you | them |
| Claude | yes | no. A personal Claude subscription cannot be attached per person; Claude always uses the fleet's |
| ChatGPT | yes | yes |
| Sees other people's chats | everyone who can reach an agent | same. Accounts change billing, not access |

## Hermes agents

Hermes agents always use the fleet's subscriptions. Per-person accounts apply
to OpenClaw agents only.
