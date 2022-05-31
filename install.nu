let local_config_dir = $"($env.USERPROFILE)\\.config\\nushell"
let dotfiles_symlink = $"($env.USERPROFILE)\\.config\\dotfiles"
let local_config_path = $"($local_config_dir)\\local-config.nu"

# Copy sample-config/local-config.nu if ~/.config/nushell/local-config.nu does not exist
if (($local_config_path | path exists) != true) {
    mkdir $"($local_config_dir)"
    cp $"($env.PWD)\\nushell\\sample-config\\local-config.nu" $"($local_config_path)"
}

if (($dotfiles_symlink | path exists) != true) {
    if ((sys).host.name == "Windows") {
        ^mklink /d $"($dotfiles_symlink)" $"($env.PWD)"
    }
    else {
        ^ln -s $env.PWD $dotfiles_symlink
    }
}

echo $"source ($env.PWD)\\nushell\\config.nu" | save $"($nu.config-path)"
echo $"source ($env.PWD)\\nushell\\env.nu" | save $"($nu.env-path)"
