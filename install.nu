let local_config_dir = "~/.config/nushell"
let dotfiles_symlink = "~/.config/dotfiles"
let local_config_path = $"($local_config_dir)/local-config.nu"
let current_dir = ($env.PWD)
let destination_path = ($nu.config-path)

# Copy sample-config/local-config.nu if ~/.config/nushell/local-config.nu does not exist
if (($local_config_path | path exists) != true) {
    mkdir $"($local_config_dir)"
    cp $"($current_dir)/nushell/sample-config/local-config.nu" $"($local_config_path)"
}

if (($dotfiles_symlink | path exists) != true) {
    if ((sys).host.name == "Windows") {
        mklink $dotfiles_symlink $current_dir
    }
    else {
        ln -s $current_dir $dotfiles_symlink
    }
}

echo $"source ($current_dir)/nushell/config.nu" | save $"(destination_path)"
