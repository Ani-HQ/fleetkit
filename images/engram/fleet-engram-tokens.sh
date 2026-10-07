#!/bin/sh
# Mint one engram token per fleet client, once. Tokens land in the shared
# fleet-secrets volume, readable only by the fleet containers' uid (1000).
# If a token file goes missing, the old token is revoked and a new one issued.
set -eu

out=/run/fleet-secrets/engram
mkdir -p "$out"
chmod 700 "$out"

for client in openclaw hermes warden; do
  file="$out/$client.token"
  [ -s "$file" ] && continue
  name="fleet-$client"
  bun cli/engram-admin.ts token revoke --name "$name" >/dev/null 2>&1 || true
  token=$(bun cli/engram-admin.ts token issue --name "$name" | tail -n 1)
  case "$token" in
    eng_*) ;;
    *) echo "engram-tokens: could not mint a token for $client" >&2; exit 1 ;;
  esac
  umask 077
  printf '%s\n' "$token" > "$file"
  echo "engram-tokens: issued $name"
done

chown -R 1000:1000 "$out"
