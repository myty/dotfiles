$env.EDITOR = 'code'

let home_path = if (sys).host.name == "Windows" {$env.USERPROFILE} else {$env.HOME}
let nushellrc_path = $"($home_path)/.nushellrc"

if (($nushellrc_path | path exists) == true) {
    nu $nushellrc_path
}

# Starship
mkdir ~/.cache/starship
starship init nu | save ~/.cache/starship/init.nu -f
