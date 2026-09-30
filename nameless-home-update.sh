#!/usr/bin/env bash
# Nameless home update (Deck side).
# Pulls the latest encrypted home bundle and refreshes ~/Desktop/nameless-home.
# No account, no token: the bundle is ciphertext at a fixed public URL.
set -u

URL="https://raw.githubusercontent.com/iceyf0x/nameless-updates/main/nameless-home.tar.gz.enc"
DEST="$HOME/Desktop/nameless-home"
CONF="$HOME/.config/nameless"
PASSFILE="$CONF/pass"
LOG="$CONF/update.log"

mkdir -p "$DEST" "$CONF"

if [ ! -s "$PASSFILE" ]; then
  echo "$(date -Is) FAIL no passphrase at $PASSFILE" >> "$LOG"
  exit 1
fi

tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT

if ! curl -fsSL "$URL" -o "$tmp"; then
  echo "$(date -Is) FAIL download" >> "$LOG"
  exit 1
fi

if ! openssl enc -d -aes-256-cbc -pbkdf2 -iter 200000 \
      -in "$tmp" -pass file:"$PASSFILE" 2>/dev/null | tar xzf - -C "$DEST" --overwrite; then
  echo "$(date -Is) FAIL decrypt/extract" >> "$LOG"
  exit 1
fi

echo "$(date -Is) OK files=$(ls -1 "$DEST" | wc -l) memory=$(wc -c < "$DEST/memory.md" 2>/dev/null)B" >> "$LOG"
