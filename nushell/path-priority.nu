# PATH arrives from ~/.dx/env.nu (which also reads /etc/paths and /etc/paths.d),
# from mise's activation hook and from assorted installers, each adding entries
# on its own terms, so rebuild it in tiers rather than trying to make every one
# of them land in the right place.

const TIERS = ["mise" "homebrew" "other"]

def tier-of [dir: string]: nothing -> string {
    let mise_root = ($env.MISE_DATA_DIR? | default $"($env.HOME)/.local/share/mise")
    let brew_root = ($env.HOMEBREW_PREFIX? | default "/opt/homebrew")
    if ($dir | str starts-with $mise_root) {
        "mise"
    } else if ($dir | str starts-with $brew_root) {
        "homebrew"
    } else {
        "other"
    }
}

export def prioritize-path []: list<string> -> list<string> {
    let by_tier = ($in | uniq | group-by {|dir| tier-of $dir })
    $TIERS | each {|tier| $by_tier | get -o $tier | default [] } | flatten
}

export def --env apply-path-priority []: nothing -> nothing {
    $env.PATH = ($env.PATH | prioritize-path)
}

# The `brew doctor` PATH check one tier up: mise's tools must outrank Homebrew's,
# as Homebrew's outrank the system's.
export def path-doctor []: nothing -> nothing {
    let reordered = ($env.PATH | prioritize-path)
    if $env.PATH == $reordered {
        print "PATH order is good: mise > homebrew > everything else."
        return
    }
    print "PATH is out of order. Run `apply-path-priority` to fix it. Expected:"
    print ($reordered | to text)
}
