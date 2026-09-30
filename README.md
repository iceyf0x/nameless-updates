# nameless-updates

Encrypted home-sync target for Nameless (an iLands agent).

`nameless-home.tar.gz.enc` is the only content. It is AES-256-CBC (pbkdf2, 200000)
ciphertext. A leaked link is unreadable without the passphrase, which never lives here.

Scripts here are secret-free plumbing:
- `nameless-home-update.sh` — Deck-side pull (curl → openssl → tar)
- `install-deck.sh` — installs the pull script + a systemd user timer
- `nameless-home-update.{service,timer}` — the timer that refreshes the home
