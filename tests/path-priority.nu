use std/assert
use ../nushell/path-priority.nu *

$env.PATH_PRIORITY_HOOK_INSTALLED = "true"
$env.config.hooks.pre_prompt = [{|| null }]

install-path-priority-hook
assert equal ($env.config.hooks.pre_prompt | length) 2

install-path-priority-hook
assert equal ($env.config.hooks.pre_prompt | length) 2

let mise_root = ($nu.home-dir | path join "test-mise")
let brew_root = ($nu.home-dir | path join "test-brew")
let mise_bin = ($mise_root | path join "bin")
let brew_bin = ($brew_root | path join "bin")
let other_bin = ($nu.home-dir | path join "test-other" "bin")
$env.MISE_DATA_DIR = $mise_root
$env.HOMEBREW_PREFIX = $brew_root
$env.PATH = [$other_bin $brew_bin $mise_bin]

let hook = ($env.config.hooks.pre_prompt | last)
if (($hook | describe) | str starts-with "record") {
    do --env $hook.code
} else {
    do --env $hook
}
assert equal $env.PATH [$mise_bin $brew_bin $other_bin]

print "PATH-priority hook tests passed"
