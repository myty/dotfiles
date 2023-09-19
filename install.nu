let dotfiles_symlink_path = $"($env.USERPROFILE)\\.config\\dotfiles"

if (($dotfiles_symlink_path | path exists) != true) {
    if ((sys).host.name == "Windows") { ^mklink /d $"($dotfiles_symlink_path)" $"($env.PWD)" } else { ^ln -s $env.PWD $dotfiles_symlink_path }
}

echo $"\n\n# Load config.nu\nsource ~\\.config\\dotfiles\\nushell\\config.nu" | save --raw --append $"($nu.config-path)"
echo $"\n\n# Load env.nu\nsource ~\\.config\\dotfiles\\nushell\\env.nu" | save --raw --append $"($nu.env-path)"
