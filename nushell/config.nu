$env.config.show_banner = false
$env.config.history.file_format = "sqlite"
$env.config.history.max_size = 100_000
$env.config.completions.case_sensitive = false
$env.config.completions.algorithm = "fuzzy"

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

# Machine-specific overrides (gitignored). `source` needs a parse-time path, so
# fall back to null (a no-op) when the file is absent.
const LOCAL_CONFIG_PATH = ($nu.home-dir | path join ".config" "dotfiles" "nushell" "local.nu")
const LOCAL_CONFIG = (if ($LOCAL_CONFIG_PATH | path exists) { $LOCAL_CONFIG_PATH } else { null })
source $LOCAL_CONFIG
