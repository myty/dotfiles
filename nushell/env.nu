# /etc/paths + /etc/paths.d/* are picked up natively by ~/.dx/env.nu,
# sourced below via ~/.nushellrc — no need to duplicate that here.

# Before refresh-autoload, so mise's cached script copies the full PATH.
source ~/.nushellrc

use ~/.config/dotfiles/nushell/autoload.nu refresh-autoload
refresh-autoload
