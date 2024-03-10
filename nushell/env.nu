$env.EDITOR = 'code'

if ("~/.nushellrc" | path exists) {
    source "~/.nushellrc"
}

# Starship
mkdir ~/.cache/starship
starship init nu | save ~/.cache/starship/init.nu -f
