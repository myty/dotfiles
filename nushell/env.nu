$env.EDITOR = 'code'

# Starship
mkdir ~/.cache/starship
starship init nu | save ~/.cache/starship/init.nu -f
