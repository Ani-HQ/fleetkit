# fleetkit fleet image: OpenClaw gateway + session-warden + fleet board.
# Hermes runs beside it from the official nousresearch/hermes-agent image.
ARG OPENCLAW_VERSION=2026.9.8
FROM ghcr.io/openclaw/openclaw:${OPENCLAW_VERSION}

ARG TARGETARCH
ARG CLAUDE_CODE_VERSION=2.1.235
ARG ENGRAM_MCP_VERSION=0.2.0
ARG SESSION_WARDEN_REPO=https://github.com/Ani-HQ/session-warden.git
ARG SESSION_WARDEN_COMMIT=1f3c266f253119f8d8418f0d821a2a768834b3d0
ARG SUPERCRONIC_VERSION=v0.2.49
ARG SUPERCRONIC_SHA256_amd64=a53ae236602c7338aba3fbaff40bda6300eae3b9fedb8261eb06cfe3724430c1
ARG SUPERCRONIC_SHA256_arm64=02aa0cb229ba09050cba6638059dadb9eedc2276632ea43d6a57a2f8c1629dd5

USER root

RUN apt-get update \
  && apt-get install -y --no-install-recommends jq python3-yaml sqlite3 procps \
  && rm -rf /var/lib/apt/lists/*

RUN set -eu; \
  sha="$(eval echo "\$SUPERCRONIC_SHA256_${TARGETARCH}")"; \
  curl -fsSL -o /usr/local/bin/supercronic \
    "https://github.com/aptible/supercronic/releases/download/${SUPERCRONIC_VERSION}/supercronic-linux-${TARGETARCH}"; \
  echo "${sha}  /usr/local/bin/supercronic" | sha256sum -c -; \
  chmod +x /usr/local/bin/supercronic

# Claude Code: the `claude-cli` runtime for Claude Pro/Max subscriptions, and
# the summarizer session-warden uses. engram-mcp: stdio bridge to engram.
RUN npm install -g --no-audit --no-fund \
    "@anthropic-ai/claude-code@${CLAUDE_CODE_VERSION}" \
    "@ani-hq/engram-mcp@${ENGRAM_MCP_VERSION}" \
  && npm cache clean --force

RUN git clone "${SESSION_WARDEN_REPO}" /opt/session-warden \
  && git -C /opt/session-warden checkout "${SESSION_WARDEN_COMMIT}" \
  && rm -rf /opt/session-warden/.git \
  && mv /opt/session-warden/config /opt/session-warden/config.dist \
  && mkdir -p /opt/session-warden/state \
  && ln -s state/config /opt/session-warden/config

COPY rootfs/ /

# session-warden and the fleet board expect a host-style home layout:
# ~/session-warden, ~/.npm-global/bin/openclaw, ~/.hermes-<agent>.
RUN chmod +x /usr/local/bin/fleet-* /usr/local/bin/systemctl /opt/fleetkit/bin/* \
  && mkdir -p /home/node/.npm-global/bin /home/node/.openclaw /home/node/.hermes \
       /home/node/.claude /run/fleet-secrets /var/lib/fleet-board \
  && ln -sf /usr/local/bin/openclaw /home/node/.npm-global/bin/openclaw \
  && ln -sfn /opt/session-warden /home/node/session-warden \
  && chown -R node:node /home/node /opt/session-warden /run/fleet-secrets \
       /var/lib/fleet-board /opt/fleetkit

USER node
ENV HOME=/home/node \
    TZ=UTC \
    WARDEN_HOME=/opt/session-warden \
    FLEETKIT_HOME=/opt/fleetkit

EXPOSE 18789 8090
ENTRYPOINT ["tini", "-s", "--", "/usr/local/bin/fleet-entrypoint"]
CMD ["gateway"]
