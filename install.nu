# Copy sample-config/local-config.nu if ~/.config/nushell/local-config.nu does not exist
let local-config-destination = $"($env.HOME)/.config/nushell"
let local-config-path = $"($local-config-destination)/local-config.nu"
let path_segment = ($env.PWD)
let destination = ($nu.config-path)

if (($local-config-path | path exists) != true) {
    mkdir $local-config-destination
    cp $"($path_segment)/nushell/sample-config/local-config.nu" $local-config-path
}

echo $"source ($path_segment)/nushell/config.nu" | save $"($destination)"
