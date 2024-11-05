$env.config.show_banner = false

# Additional config
source "~/.config/dotfiles/nushell/aliases.nu"
source "~/.config/dotfiles/nushell/commands.nu"

# Custom aliases from nu_scripts
use "~/.config/dotfiles/nushell/nu_scripts/custom-completions/git/git-completions.nu" *
use "~/.config/dotfiles/nushell/nu_scripts/custom-completions/gh/gh-completions.nu" *
use "~/.config/dotfiles/nushell/nu_scripts/custom-completions/npm/npm-completions.nu" *
use "~/.config/dotfiles/nushell/nu_scripts/custom-completions/docker/docker-completions.nu" *
use "~/.config/dotfiles/nushell/nu_scripts/custom-completions/dotnet/dotnet-completions.nu" *
use "~/.config/dotfiles/nushell/nu_scripts/custom-completions/scoop/scoop-completions.nu" *

source ~/.config/dotfiles/nushell/modules/fnm/fnm.nu

# Load Starship
source ~/.cache/starship/init.nu
