$env.EDITOR = 'code'
$env.config.buffer_editor = 'code'

touch ~/.nushellrc
source ~/.nushellrc

# Mise
let mise_path = $nu.default-config-dir | path join mise.nu
^mise activate nu | save $mise_path --force

# Starship
mkdir ~/.cache/starship
starship init nu | save ~/.cache/starship/init.nu -f
