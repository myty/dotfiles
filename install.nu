let home_path = match $nu.os-info.name {
    "windows" => $"($env.USERPROFILE)",
    _ => $"($env.HOME)",
  }

let dotfiles_symlink_path = $"($home_path)/.config/dotfiles"

if (($dotfiles_symlink_path | path exists) != true) {
    if $nu.os-info.name == "windows" {
        ^mklink /d $"($dotfiles_symlink_path)" $"($env.PWD)"
    } else {
        ^ln -s $env.PWD $dotfiles_symlink_path
    }
}

config reset

echo $"\n# Load config.nu\nsource ~/.config/dotfiles/nushell/config.nu\n" | save --raw --append $"($nu.config-path)"
echo $"\n# Load env.nu\nsource ~/.config/dotfiles/nushell/env.nu\n" | save --raw --append $"($nu.env-path)"

^deno install -gfr --allow-run --allow-read -n git-gone jsr:@myty/git-gone
