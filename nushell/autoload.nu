# Tools like mise, starship, zoxide and carapace print a nushell init script.
# Regenerating those on every shell start is slow, so write each one into
# nushell's vendor autoload dir (loaded automatically) and only refresh it when
# the tool's binary is newer than the cached script (or, for mise, when PATH
# has an entry the cached script lacks).

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

# mise copies the current PATH into its script and restores that copy at
# startup, so a script generated before a PATH entry was added (e.g. in
# ~/.nushellrc) silently drops it. mise leaves its own tool directories out of
# the copy, so those don't count as missing.
#
# A shell started from one where mise is already active inherits extra entries
# from mise (e.g. ~/.cargo/bin) that would look missing, so only the outermost
# shell checks; nested shells inherit its PATH anyway.
def mise-script-misses-path-entries [script: path]: nothing -> bool {
    if "MISE_SHELL" in $env { return false }

    let mise_data_dir = if $nu.os-info.name == "windows" {
        $env.MISE_DATA_DIR? | default ($env.LOCALAPPDATA | path join "mise")
    } else {
        $env.MISE_DATA_DIR? | default ($nu.home-dir | path join ".local" "share" "mise")
    }
    let script_path = (
        open --raw $script
        | parse --regex "\\$env\\.PATH = \\(r#'(?<path>[^']*)'#"
        | get -o 0.path
        | default ""
        | split row (char esep)
    )
    $env.PATH
    | split row (char esep)
    | where {|dir| not ($dir | str starts-with $mise_data_dir) }
    | any {|dir| $dir not-in $script_path }
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
        let stale = (is-stale $script $binary) or (
            $generator.name == "mise" and (mise-script-misses-path-entries $script)
        )
        if $stale {
            ^$binary ...$generator.args | save --force $script
        }
    }

    let priority_script = ($autoload_dir | path join "zz-path-priority.nu")
    if not ($priority_script | path exists) or (open --raw $priority_script) != $PATH_PRIORITY_SCRIPT {
        $PATH_PRIORITY_SCRIPT | save --force --raw $priority_script
    }
}
