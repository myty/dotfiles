$env.config.show_banner = false

# Additional config
source "~/.config/dotfiles/nushell/aliases.nu"
source "~/.config/dotfiles/nushell/commands.nu"

# Custom aliases from nu_scripts
use "~/.config/dotfiles/nushell/nu_scripts/custom-completions/git/git-completions.nu" *
use "~/.config/dotfiles/nushell/nu_scripts/custom-completions/npm/npm-completions.nu" *
use "~/.config/dotfiles/nushell/nu_scripts/custom-completions/scoop/scoop-completions.nu" *
# use "~/.config/dotfiles/nushell/nu_scripts/custom-completions/winget/winget-completions.nu" *

# Load Starship
source ~/.cache/starship/init.nu
