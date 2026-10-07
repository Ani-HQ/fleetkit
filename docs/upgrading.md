# Upgrading and backups

## Update

```bash
./fleet backup
./fleet update
```

`update` pulls the latest fleetkit, pulls new images and restarts. Your `fleet.yaml`, `.env`, logins, sessions and memory are kept.

To stay on a version, set `FLEETKIT_VERSION=0.1.0` (any release tag) in `.env`. To move, change it and run `./fleet up`.

## Change agents

Edit `fleet.yaml` and run `./fleet up`. New agents get a starter persona. Existing agents keep theirs. Removing an agent from `fleet.yaml` stops routing messages to it but keeps its files.

## Backup

```bash
./fleet backup
```

This writes `backups/fleet-<time>/` with `fleet.yaml`, `.env`, a tarball for each volume, and a database dump. Copy it off the server: `scp -r server:fleetkit/backups .`

## Restore on a new server

```bash
git clone https://github.com/Ani-HQ/fleetkit && cd fleetkit
cp /path/to/backup/fleet.yaml /path/to/backup/.env .
for v in openclaw hermes claude warden fleet-secrets engram-homes; do
  docker volume create fleet_$v
  docker run --rm -v fleet_$v:/v -v /path/to/backup:/b alpine tar -xzf /b/$v.tgz -C /v
done
COMPOSE_PROFILES=memory docker compose up -d db
gunzip -c /path/to/backup/engram-db.sql.gz | docker compose exec -T db psql -U postgres
./fleet up
```

## Build images yourself

`FLEET_BUILD=1 ./fleet up` builds both images from `images/` instead of pulling them.
