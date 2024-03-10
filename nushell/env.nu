$env.EDITOR = 'code'

let home_path = if (sys).host.name == "Windows" {$env.USERPROFILE} else {$env.HOME}
let nushell_rc = $"($home_path)/.nushellrc"
if ($nushell_rc | path exists) {
    nu $nushell_rc
}

# Starship
mkdir ~/.cache/starship
starship init nu | save ~/.cache/starship/init.nu -f
