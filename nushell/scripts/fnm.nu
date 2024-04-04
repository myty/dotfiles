export-env {
  $env.config = ($env.config | upsert hooks {
      env_change: {
          PWD: ($env.config.hooks.env_change.PWD ++
            [{
                condition: {|before, after| [.nvmrc .node-version] | path exists | any { |it| $it }}
                code: {|before, after|
                    if ('FNM_DIR' in $env) {
                        fnm --log-level=quiet use
                    }
                }
            }]
        )
      }
  })
}


if not (which fnm | is-empty) {
  ^fnm env --json | from json | load-env
  # Checking `Path` for Windows
  let path = if 'Path' in $env { $env.Path } else { $env.PATH }
  let node_path = if (sys).host.name == 'Windows' {
    $"($env.FNM_MULTISHELL_PATH)"
  } else {
    $"($env.FNM_MULTISHELL_PATH)/bin"
  }
  $env.PATH = ($path | prepend [ $node_path ])
}
