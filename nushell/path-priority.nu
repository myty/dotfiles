# PATH arrives from ~/.dx/env.nu (which also reads /etc/paths and /etc/paths.d),
# from mise's activation hook and from assorted installers, each adding entries
# on its own terms, so rebuild it in tiers rather than trying to make every one
# of them land in the right place. Tiers, highest priority first: mise,
# Homebrew (if present), everything else.

def tier-roots []: nothing -> list<string> {
    let mise_root = if $nu.os-info.name == "windows" {
        $env.MISE_DATA_DIR? | default ($env.LOCALAPPDATA | path join "mise")
    } else {
        $env.MISE_DATA_DIR? | default ($nu.home-dir | path join ".local" "share" "mise")
    }
    [$mise_root, $env.HOMEBREW_PREFIX?] | compact --empty
}

def is-under [dir: string, root: string]: nothing -> bool {
    let fold = {|p| if $nu.os-info.name == "windows" { $p | str lowercase } else { $p } }
    let dir = (do $fold $dir)
    let root = (do $fold $root)
    $dir == $root or ($dir | str starts-with ($root | path join ""))
}

export def prioritize-path []: list<string> -> list<string> {
    let roots = (tier-roots)
    let other_tier = ($roots | length)
    $in
    | uniq
    | enumerate
    | insert tier {|entry|
        $roots
        | enumerate
        | where {|root| is-under $entry.item $root.item }
        | get -o 0.index
        | default $other_tier
    }
    | sort-by tier index
    | get item
}

export def --env apply-path-priority []: nothing -> nothing {
    let reordered = ($env.PATH | prioritize-path)
    if $env.PATH != $reordered {
        $env.PATH = $reordered
    }
}

# Registers apply-path-priority as a pre_prompt hook, once per session.
export def --env install-path-priority-hook []: nothing -> nothing {
    let hooks = ($env.config.hooks.pre_prompt? | default [])
    let installed = ($hooks | any {|hook| (try { $hook.__path_priority_hook? } catch { null }) == true })
    if $installed { return }
    let hook = { __path_priority_hook: true, code: { apply-path-priority } }
    $env.config.hooks.pre_prompt = ($hooks | append $hook)
}
