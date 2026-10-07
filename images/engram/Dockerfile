# engram (shared agent memory) + pinned gbrain, built from upstream source.
# Mirrors https://github.com/Ani-HQ/engram/blob/main/Dockerfile without the
# Cloud SQL proxy, plus the fleet token minter.
FROM oven/bun:1-debian

RUN apt-get update \
  && apt-get install -y --no-install-recommends git ca-certificates python3 \
  && rm -rf /var/lib/apt/lists/*

# Bump deliberately. Never build from HEAD.
ARG ENGRAM_REPO=https://github.com/Ani-HQ/engram.git
ARG ENGRAM_COMMIT=240c9646c8d81ab08e2b58283e101e1feb251c2d
ARG GBRAIN_REPO=https://github.com/Ani-HQ/gbrain.git
ARG GBRAIN_COMMIT=4922905fb970d7014625a0190136fbfc8a4f36b0

RUN git clone ${ENGRAM_REPO} /app \
  && git -C /app checkout ${ENGRAM_COMMIT} \
  && rm -rf /app/.git

RUN git clone ${GBRAIN_REPO} /opt/gbrain \
  && git -C /opt/gbrain checkout ${GBRAIN_COMMIT} \
  && python3 /app/deploy/patch-gbrain.py /opt/gbrain/src/core/migrate.ts \
  && cd /opt/gbrain && bun install --frozen-lockfile \
  && printf '#!/bin/sh\nexec bun /opt/gbrain/src/cli.ts "$@"\n' > /usr/local/bin/gbrain \
  && chmod +x /usr/local/bin/gbrain
ENV GBRAIN_BIN=/usr/local/bin/gbrain

WORKDIR /app
RUN bun install \
  && rm -f .env.local \
  && chmod +x deploy/entrypoint.sh

COPY fleet-engram-tokens.sh /usr/local/bin/fleet-engram-tokens

ENV GBRAIN_HOMES_DIR=/gbrain-homes
ENV PORT=8080
EXPOSE 8080
CMD ["/app/deploy/entrypoint.sh"]
