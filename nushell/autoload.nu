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

# Autoload scripts run after config.nu, in alphabetical order, and mise's
# pre_prompt hook rewrites PATH wholesale. Name this one to sort after mise.nu
# so path-priority's hook runs after mise's and has the last word.
const PATH_PRIORITY_SCRIPT = '
use ~/.config/dotfiles/nushell/path-priority.nu *
apply-path-priority
install-path-priority-hook
'

# env.nu runs before mise has put its tools on PATH, so ask mise directly.
def find-binary [name: string]: nothing -> any {
    let on_path = (which $name | get -o 0.path)
    if $on_path != null { return $on_path }
    if (which mise | is-empty) { return null }

    let from_mise = (do { ^mise which $name } | complete)
    if $from_mise.exit_code == 0 { $from_mise.stdout | str trim } else { null }
}

export def refresh-autoload []: nothing -> nothing {
    let autoload_dir = ($nu.data-dir | path join "vendor" "autoload")
    mkdir $autoload_dir

    for generator in $GENERATORS {
        let binary = (find-binary $generator.name)
        if $binary == null { continue }

        let script = ($autoload_dir | path join $"($generator.name).nu")
        if (is-stale $script $binary) {
            ^$binary ...$generator.args | save --force $script
        }
    }

    let priority_script = ($autoload_dir | path join "zz-path-priority.nu")
    if not ($priority_script | path exists) or (open --raw $priority_script) != $PATH_PRIORITY_SCRIPT {
        $PATH_PRIORITY_SCRIPT | save --force --raw $priority_script
    }
}
