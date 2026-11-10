# /etc/paths + /etc/paths.d/* are picked up natively by ~/.dx/env.nu,
# sourced below via ~/.nushellrc — no need to duplicate that here.

use ~/.config/dotfiles/nushell/autoload.nu refresh-autoload
refresh-autoload

source ~/.nushellrc
