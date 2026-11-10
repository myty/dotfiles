# dotfiles

Cross-platform dotfiles, centered on [Nushell](https://www.nushell.sh).

## Install

```nu
git clone https://github.com/myty/dotfiles
cd dotfiles
nu install.nu
```

`install.nu` is idempotent. It:

1. Symlinks the repo to `~/.config/dotfiles` (Windows needs developer mode or admin).
2. Appends `source` lines to Nushell's `env.nu` and `config.nu`, if missing.
3. Seeds `~/.nushellrc` from `examples/.nushellrc.example` if absent.

## Layout

| Path | Purpose |
| --- | --- |
| `nushell/env.nu` | Sources `~/.nushellrc` (machine-specific env, mise, starship, dx) |
| `nushell/config.nu` | Main config; loads aliases, commands, PATH priority |
| `nushell/aliases.nu`, `commands.nu` | Aliases and custom commands |
| `nushell/autoload.nu` | Caches mise/starship/zoxide/carapace init scripts in the vendor autoload dir; regenerated only when the binary is newer |
| `nushell/local.nu` | Optional, gitignored, machine-specific overrides loaded last by `config.nu` |
| `nushell/path-priority.nu` | Keeps PATH ordered: mise > homebrew > rest |
| `mise.toml` | Dev tool versions |
