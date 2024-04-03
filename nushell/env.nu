$env.EDITOR = 'code'

touch ~/.nushellrc
source ~/.nushellrc

# Starship
mkdir ~/.cache/starship
starship init nu | save ~/.cache/starship/init.nu -f
