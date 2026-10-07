# Connect your AI subscriptions

fleetkit never asks for an API key. Agents sign in to your subscriptions the same way the official apps do, so you pay your normal monthly plan and nothing per token.

List the ones you have in `fleet.yaml`:

```yaml
subscriptions: [claude, chatgpt]
```

## Claude (Pro or Max)

```bash
./fleet login claude
```

1. A link appears. Open it on any device and approve.
2. Paste the code it shows back into the terminal.
3. Claude prints a long token starting with `sk-ant-oat01-`. Paste it when asked.

The token lasts a year and is stored in the `fleet-secrets` volume. OpenClaw agents run Claude through the official `claude` CLI, so they use your plan's limits.

Hermes agents can use Claude too, but Anthropic only allows third-party apps on **Max with extra usage** turned on. On Pro, keep Hermes agents on ChatGPT.

## ChatGPT (Plus or Pro)

```bash
./fleet login chatgpt
```

You'll see a short code and a link. Open the link, sign in to ChatGPT, enter the code. This runs once for OpenClaw, then once per Hermes agent (each Hermes agent keeps its own login).

OpenClaw agents run ChatGPT models through Codex, the same engine as the Codex app.

## Which agent uses which

| Agent | First choice | Falls back to |
| --- | --- | --- |
| builder | ChatGPT | Claude |
| other OpenClaw agents | Claude | ChatGPT |
| Hermes agents | ChatGPT | Claude (Max only) |

If you only have one subscription, every agent uses it. To pin a model, set `model:` on an agent in `fleet.yaml`, e.g. `model: anthropic/claude-opus-4-8`.

## session-warden

The warden's nightly reflection and weekly review use Claude. With ChatGPT only, the warden still rotates sessions and guards rate limits, but those Claude jobs are skipped.

## Several people

Everyone listed under `people` in `fleet.yaml` shares these subscriptions. A
person can connect their own ChatGPT on top, and their new chats bill that
account instead. See [Several people, one fleet](people.md).

## Re-logging in

Logins expire rarely. If an agent replies with an auth error, run the same `./fleet login` command again. To switch accounts: `./fleet openclaw models auth login --provider openai --device-code --force`.
