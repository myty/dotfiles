# Idempotent: safe to re-run. Links this repo to ~/.config/dotfiles and wires
# env.nu / config.nu to source the repo's versions.

let home = if $nu.os-info.name == "windows" { $env.USERPROFILE } else { $env.HOME }
let link = ($home | path join ".config" "dotfiles")

if not ($link | path exists) {
  print $"Creating symlink at ($link) to ($env.PWD)"
  mkdir ($link | path dirname)
  if $nu.os-info.name == "windows" {
    ^cmd /c mklink /d $link $env.PWD
  } else {
    ^ln -s $env.PWD $link
  }
}

def ensure-sourced [target: path, line: string] {
  if not ($target | path exists) { touch $target }
  if not ((open --raw $target) | str contains $line) {
    print $"Adding to ($target): ($line)"
    $"\n# dotfiles\n($line)\n" | save --raw --append $target
  }
}

ensure-sourced $nu.env-path "source ~/.config/dotfiles/nushell/env.nu"
ensure-sourced $nu.config-path "source ~/.config/dotfiles/nushell/config.nu"

let rc = ($home | path join ".nushellrc")
if not ($rc | path exists) {
  print $"Seeding ($rc) from examples/.nushellrc.example"
  cp examples/.nushellrc.example $rc
}
