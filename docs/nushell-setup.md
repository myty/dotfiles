# Nushell setup and doctor

Use this guide when setting up these dotfiles on a machine or diagnosing and improving its `~/.nushellrc`. That file is machine-local and may contain private settings; never copy its secrets into the repo or include them in reports.

## Set up

1. Identify the OS, home directory, installed Nushell and mise, and the checkout location. Check the prerequisites in `README.md`.
2. Before installing, inspect any existing `~/.config/dotfiles` and mise configuration symlinks. `install.nu` leaves existing paths in place: confirm they point to the intended checkout and files rather than assuming a rerun repairs them. Resolve conflicts with the user before replacing anything.
3. Follow the install steps in `README.md`: run `nu install.nu` from the repo root, then `mise install`. On Windows, symlinks require developer mode or an elevated shell.
4. The installer seeds `~/.nushellrc` from `examples/.nushellrc.example` only when absent. Inspect the resulting file before editing; preserve existing customizations. Never overwrite an existing rc with the template.
5. Adapt the rc to this machine:
   - Set `$env.EDITOR` and `$env.config.buffer_editor` to `code` when the `code` CLI is available. If it is not, preserve an existing editor choice; otherwise ask the user which installed editor to use.
   - Provide an `up` command for maintenance. When invoked, it should update and upgrade Homebrew packages and clean up if Homebrew is installed; update mise tools, prune unused versions and reshim if mise is installed; upgrade GitHub CLI extensions if `gh` is installed; and update global skills if the `skills` CLI is installed. Check each executable independently at invocation time, use flags supported by the installed version, and skip unavailable tools. Do not run these updates as part of setup or verification. Do not add automatic elevation; ask before any operation requiring it.
   - Add PATH entries only when the platform and installed tools need them. Use `$nu.home-dir` and `path join` for home-relative paths; avoid hard-coded paths from another machine. The repo's generated PATH hook already prioritizes mise and Homebrew, so don't duplicate its ordering logic.
   - Set `GPG_TTY` only where a usable terminal and `tty` are available; avoid making non-interactive startup fail.
   - Leave work-specific `~/.dx/env.nu` and other optional local scripts, such as LiteLLM, to the user unless requested. If adding a source, verify it exists and use a Nushell parse-time-safe optional path; an absent optional file must not break startup.

## Doctor

1. Ask about symptoms and the intended change; inspect the rc, the repo's startup files, relevant generated autoload scripts, tool availability and existing symlinks. Account for startup order in `README.md`. Distinguish machine-local issues from repo issues before changing either.
2. Preserve unrelated settings and private values. Make the smallest change that fixes the problem or implements the agreed improvement. Ask before removing or replacing existing customizations, changing symlinks, installing tools, or running maintenance commands with side effects.
3. Parse-check changed Nushell files with absolute paths using the command in `AGENTS.md`. Check actual startup in a new interactive Nushell: on Unix, the PTY command in `AGENTS.md` can be used; on Windows, use an interactive terminal. Confirm the reported symptom is fixed, relevant tools and PATH resolve as intended, and optional missing tools do not break startup. Do not invoke `up` just to test it; inspect its definition and report any behavior that could not be verified safely.
4. Report changes, checks and any remaining failures or manual steps without exposing secrets.
