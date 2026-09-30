#!/usr/bin/env bash
# Deck installer for the Nameless home updater.
# Puts the pull script + systemd units in place and switches the timer on.
# The passphrase is NOT here: create ~/.config/nameless/pass before running this.
set -euo pipefail

RAW="https://raw.githubusercontent.com/iceyf0x/nameless-updates/main"
BIN="$HOME/.local/bin"
UNIT="$HOME/.config/systemd/user"
CONF="$HOME/.config/nameless"

mkdir -p "$BIN" "$UNIT" "$CONF"

if [ ! -s "$CONF/pass" ]; then
  echo "Missing passphrase file: $CONF/pass"
  echo "Create it first, then re-run this installer."
  exit 1
fi

curl -fsSL "$RAW/nameless-home-update.sh"        -o "$BIN/nameless-home-update.sh"
chmod +x "$BIN/nameless-home-update.sh"
curl -fsSL "$RAW/nameless-home-update.service"   -o "$UNIT/nameless-home-update.service"
curl -fsSL "$RAW/nameless-home-update.timer"     -o "$UNIT/nameless-home-update.timer"

systemctl --user daemon-reload
systemctl --user enable --now nameless-home-update.timer

"$BIN/nameless-home-update.sh"
echo "--- timer ---"
systemctl --user list-timers nameless-home-update.timer --no-pager
echo "--- update log ---"
tail -3 "$CONF/update.log"
echo "installed"
