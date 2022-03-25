# Local only config for such things as aliases, commands, paths, environment variables, etc.

# let-env PATH = ($env.PATH | append "some/other/path")

# Additional config
source "~/dev/github/myty/dotfiles/nushell/aliases.nu"
source "~/dev/github/myty/dotfiles/nushell/commands.nu"

# Custom completions for external commands (those outside of Nushell)
source "~/dev/github/myty/dotfiles/nushell/nu_scripts/custom-completions/git/git-completions.nu"
source "~/dev/github/myty/dotfiles/nushell/nu_scripts/custom-completions/winget/winget-completions.nu"
source "~/dev/github/myty/dotfiles/nushell/nu_scripts/custom-completions/cargo/cargo-completions.nu"
# source "~/dev/github/myty/dotfiles/nushell/nu_scripts/custom-completions/make/make-completions.nu"
# source "~/dev/github/myty/dotfiles/nushell/nu_scripts/custom-completions/npm/npm-completions.nu"