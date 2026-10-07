#!/usr/bin/env bash
# Install fleetkit on a fresh Ubuntu or Debian server:
#   curl -fsSL https://raw.githubusercontent.com/Ani-HQ/fleetkit/main/install.sh | bash
set -euo pipefail

REPO="${FLEETKIT_REPO:-https://github.com/Ani-HQ/fleetkit.git}"
BRANCH="${FLEETKIT_BRANCH:-main}"
DIR="${FLEETKIT_DIR:-$HOME/fleetkit}"

say() { printf '\033[1m==> %s\033[0m\n' "$*"; }
die() { printf 'install: %s\n' "$*" >&2; exit 1; }

SUDO=""
if [ "$(id -u)" != 0 ]; then
  command -v sudo >/dev/null || die "run as root or install sudo"
  SUDO="sudo"
fi

[ -r /etc/os-release ] && . /etc/os-release
case "${ID:-}${ID_LIKE:-}" in
  *debian*|*ubuntu*) ;;
  *) die "this installer supports Ubuntu and Debian. Elsewhere: install Docker + git, clone $REPO, run ./fleet setup" ;;
esac

mem_mb=$(awk '/MemTotal/{print int($2/1024)}' /proc/meminfo)
[ "$mem_mb" -ge 3500 ] || printf '  ! %s MB RAM. 4 GB is the minimum for the full fleet.\n' "$mem_mb"

say "installing packages"
$SUDO apt-get update -qq
$SUDO apt-get install -y -qq git openssl python3 ca-certificates curl >/dev/null

if ! command -v docker >/dev/null; then
  say "installing Docker"
  curl -fsSL https://get.docker.com | $SUDO sh >/dev/null
fi
$SUDO systemctl enable --now docker >/dev/null 2>&1 || true
if [ -n "$SUDO" ] && ! id -nG | grep -qw docker; then
  $SUDO usermod -aG docker "$(id -un)"
  NEED_RELOGIN=1
fi

if [ -d "$DIR/.git" ]; then
  say "updating $DIR"
  git -C "$DIR" pull --ff-only
else
  say "cloning fleetkit into $DIR"
  git clone --depth 1 --branch "$BRANCH" "$REPO" "$DIR"
fi

say "done"
echo
if [ -n "${NEED_RELOGIN:-}" ]; then
  echo "  Log out and back in once (so Docker works without sudo), then:"
else
  echo "  Next:"
fi
echo "    cd $DIR"
echo "    ./fleet setup"
echo "    ./fleet up"
echo "    ./fleet login claude    # and/or: ./fleet login chatgpt"
