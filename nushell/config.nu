$env.config.show_banner = false

# Additional config
source "~/.config/dotfiles/nushell/aliases.nu"
source "~/.config/dotfiles/nushell/commands.nu"

# # Custom aliases from nu_scripts
# use "~/.config/dotfiles/nushell/nu_scripts/custom-completions/git/git-completions.nu" *
# use "~/.config/dotfiles/nushell/nu_scripts/custom-completions/gh/gh-completions.nu" *
# use "~/.config/dotfiles/nushell/nu_scripts/custom-completions/npm/npm-completions.nu" *
# use "~/.config/dotfiles/nushell/nu_scripts/custom-completions/docker/docker-completions.nu" *
# use "~/.config/dotfiles/nushell/nu_scripts/custom-completions/scoop/scoop-completions.nu" *

# mise rewrites PATH wholesale after env.nu runs and again from its pre_prompt
# hook, so re-apply the tiering after each of its runs. Hooks run in
# registration order, and mise registers its own before this file loads.
use ~/.config/dotfiles/nushell/path-priority.nu *
install-path-priority-hook
