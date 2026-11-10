# Tools like mise, starship, zoxide and carapace print a nushell init script.
# Regenerating those on every shell start is slow, so write each one into
# nushell's vendor autoload dir (loaded automatically) and only refresh it when
# the tool's binary is newer than the cached script.

const GENERATORS = [
    { name: "starship", args: [init nu] }
    { name: "mise", args: [activate nu] }
    { name: "zoxide", args: [init nushell] }
    { name: "carapace", args: [_carapace nushell] }
]

def is-stale [script: path, binary: path]: nothing -> bool {
    if not ($script | path exists) { return true }
    (ls ($binary | path expand) | get 0.modified) > (ls $script | get 0.modified)
}

export def refresh-autoload []: nothing -> nothing {
    let autoload_dir = ($nu.data-dir | path join "vendor" "autoload")
    mkdir $autoload_dir

    for generator in $GENERATORS {
        let binary = (which $generator.name | get -o 0.path)
        if $binary == null { continue }

        let script = ($autoload_dir | path join $"($generator.name).nu")
        if (is-stale $script $binary) {
            ^$binary ...$generator.args | save --force $script
        }
    }
}
