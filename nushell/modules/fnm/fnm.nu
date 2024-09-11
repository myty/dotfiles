if not (which fnm | is-empty) {
  ^fnm env --resolve-engines --corepack-enabled --json | from json | load-env

  let node_path = match $nu.os-info.name {
    "windows" => $"($env.FNM_MULTISHELL_PATH)",
    _ => $"($env.FNM_MULTISHELL_PATH)/bin",
  }
  $env.PATH = ($env.PATH | prepend [ $node_path ])
}

$env.config = ($env.config | merge {
  hooks: {
    env_change: {
      PWD: [{
        if ([.nvmrc .node-version] | path exists | any { |it| $it }) {
          fnm use
        } else {
          fnm --log-level=quiet use default
        }
      }]
    }
  }
})
