# dotfiles

Cross-platform dotfiles for [Nushell](https://www.nushell.sh) on macOS, Linux and Windows. Tool versions come from [mise](https://mise.jdx.dev).

## What you get

- **Prompt and navigation:** [starship](https://starship.rs) prompt and [zoxide](https://github.com/ajeetdsouza/zoxide) (`z <dir>` jumps to frequently used directories, `zi` picks one interactively with [fzf](https://github.com/junegunn/fzf)).
- **Completions:** [carapace](https://carapace.sh) completes most CLIs (`git`, `gh`, `docker`, `mise`, `dotnet` and more); fuzzy, case-insensitive matching.
- **Tool versions:** `mise/shell-tools.toml` provides the shell tools globally, and `mise.toml` pins the dev runtimes for this repo.
- **PATH order:** mise tools first, then Homebrew, then everything else, kept that way even when mise or an installer rewrites `PATH`.
- **History:** SQLite-backed, 100k entries.
- **Aliases and commands:** `cls`, `gp`, `gam` (amend without editing), `gpr` (pull with rebase).

## Prerequisites

[Nushell](https://www.nushell.sh/book/installation.html) and [mise](https://mise.jdx.dev/getting-started.html). After `nu install.nu`, run `mise install` to get the shell tools (starship, zoxide, carapace, fzf). Run it inside this repo to also install the runtimes in `mise.toml`. Tools that aren't installed are skipped, so the config works without them.

## Install

```nu
git clone https://github.com/myty/dotfiles
cd dotfiles
nu install.nu
```

`install.nu` is safe to re-run. It:

1. Symlinks the repo to `~/.config/dotfiles`. Windows needs developer mode or an elevated shell.
2. Appends `source` lines to Nushell's `env.nu` and `config.nu`, if they're missing.
3. Symlinks `mise/shell-tools.toml` into `~/.config/mise/conf.d/`, which mise merges into its global config so the shell tools work from any directory.
4. Seeds `~/.nushellrc` from `examples/.nushellrc.example`, if it doesn't exist.

Open a new shell afterwards.

## How it loads

Nushell starts in this order, and the order matters:

1. `nushell/env.nu` generates tool init scripts (below), then sources `~/.nushellrc`.
2. `nushell/config.nu` sets options, then sources `aliases.nu`, `commands.nu` and an optional `local.nu`.
3. Nushell's vendor autoload directory loads the generated scripts alphabetically: `carapace`, `mise`, `starship`, `zoxide`, then `zz-path-priority`.

`nushell/autoload.nu` writes the generated scripts. It regenerates one only when that tool's binary is newer than the cached script, so shell startup stays fast. The `zz-` prefix makes the PATH script sort after mise's, so its hook runs last.

## Layout

| Path | Purpose |
| --- | --- |
| `install.nu` | Idempotent installer |
| `mise/shell-tools.toml` | Shell tools, linked into mise's global `conf.d/` |
| `mise.toml` | Dev runtimes, active only inside this repo |
| `nushell/env.nu` | Refreshes generated init scripts, sources `~/.nushellrc` |
| `nushell/config.nu` | Shell options; loads aliases, commands and `local.nu` |
| `nushell/aliases.nu`, `commands.nu` | Aliases and custom commands |
| `nushell/autoload.nu` | Generates and caches init scripts in the vendor autoload dir |
| `nushell/path-priority.nu` | The PATH ordering logic and its `pre_prompt` hook |
| `nushell/nu_scripts` | Submodule of the `myty/nu_scripts` fork (not loaded by default) |
| `examples/.nushellrc.example` | Template for `~/.nushellrc` |

## Customize

- **Machine-specific environment:** edit `~/.nushellrc`. It lives outside the repo, and `env.nu` sources it before everything else. It's the place for `$env.EDITOR`, tokens and local-only commands.
- **Machine-specific shell config:** create `nushell/local.nu`. It's gitignored and loaded last by `config.nu`.
- **Check PATH order:** `$env.PATH | first 10` should list mise paths, then Homebrew's.

## Maintenance

- **CI** (`.github/workflows/check.yml`): runs `install.nu` on Linux, macOS and Windows, then parse-checks every Nushell file.
- **`nu_scripts` fork:** `sync_nu_scripts_fork.yml` fast-forwards `myty/nu_scripts` from upstream daily. It needs a repository secret, `NU_SCRIPTS_FORK_TOKEN`: a fine-grained PAT with Contents read/write on `myty/nu_scripts` only.
- **Dependabot:** bumps the submodule and GitHub Actions versions weekly.
