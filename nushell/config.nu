# Nushell Config File

# Load local-config.nu
source ~/.config/nushell/local-config.nu

# Starship
let-env STARSHIP_SHELL = "nu"
hide PROMPT_COMMAND_RIGHT
let-env PROMPT_INDICATOR = " "
let-env PROMPT_COMMAND = { starship prompt --cmd-duration $env.CMD_DURATION_MS --status $env.LAST_EXIT_CODE | str trim }

# Additional config
source "~/.config/dotfiles/nushell/aliases.nu"
source "~/.config/dotfiles/nushell/commands.nu"

# Custom completions for external commands (those outside of Nushell)
use "~/.config/dotfiles/nushell/nu_scripts/custom-completions/git/git-completions.nu" *
use "~/.config/dotfiles/nushell/nu_scripts/custom-completions/winget/winget-completions.nu" *
use "~/.config/dotfiles/nushell/nu_scripts/custom-completions/cargo/cargo-completions.nu" *
use "~/.config/dotfiles/nushell/nu_scripts/custom-completions/npm/npm-completions.nu" *

# for more information on themes see
# https://www.nushell.sh/book/coloring_and_theming.html
let default_theme = {
    # color for nushell primitives
    separator: white
    leading_trailing_space_bg: { attr: n } # no fg, no bg, attr none effectively turns this off
    header: green_bold
    empty: blue
    bool: white
    int: white
    filesize: white
    duration: white
    date: white
    range: white
    float: white
    string: white
    nothing: white
    binary: white
    cellpath: white
    row_index: green_bold
    record: white
    list: white
    block: white
    hints: dark_gray

    # shapes are used to change the cli syntax highlighting
    shape_garbage: { fg: "#FFFFFF" bg: "#FF0000" attr: b}
    shape_binary: purple_bold
    shape_bool: light_cyan
    shape_int: purple_bold
    shape_float: purple_bold
    shape_range: yellow_bold
    shape_internalcall: cyan_bold
    shape_external: cyan
    shape_externalarg: green_bold
    shape_literal: blue
    shape_operator: yellow
    shape_signature: green_bold
    shape_string: green
    shape_string_interpolation: cyan_bold
    shape_datetime: cyan_bold
    shape_list: cyan_bold
    shape_table: blue_bold
    shape_record: cyan_bold
    shape_block: blue_bold
    shape_filepath: cyan
    shape_globpattern: cyan_bold
    shape_variable: purple
    shape_flag: blue_bold
    shape_custom: green
    shape_nothing: light_cyan
}

# The default config record. This is where much of your global configuration is setup.
let-env config = {
  filesize_metric: false
  table_mode: rounded # basic, compact, compact_double, light, thin, with_love, rounded, reinforced, heavy, none, other
  use_ls_colors: true
  rm_always_trash: false
  color_config: $default_theme
  use_grid_icons: true
  footer_mode: "25" # always, never, number_of_rows, auto
  quick_completions: true  # set this to false to prevent auto-selecting completions when only one remains
  partial_completions: true  # set this to false to prevent partial filling of the prompt
  completion_algorithm: "prefix"  # prefix, fuzzy
  animate_prompt: false # redraw the prompt every second
  float_precision: 2
  buffer_editor: "emacs" # command that will be used to edit the current line buffer with ctr+e
  use_ansi_coloring: true
  filesize_format: "auto" # b, kb, kib, mb, mib, gb, gib, tb, tib, pb, pib, eb, eib, zb, zib, auto
  edit_mode: emacs # emacs, vi
  max_history_size: 10000 # Session has to be reloaded for this to take effect
  sync_history_on_enter: true # Enable to share the history between multiple sessions, else you have to close the session to persist history to file
  shell_integration: true # enables terminal markers and a workaround to arrow keys stop working issue
  disable_table_indexes: false # set to true to remove the index column from tables
  menus: [
      # Configuration for default nushell menus
      # Note the lack of souce parameter
      {
        name: completion_menu
        only_buffer_difference: false
        marker: "| "
        type: {
            layout: columnar
            columns: 4
            col_width: 20   # Optional value. If missing all the screen width is used to calculate column width
            col_padding: 2
        }
        style: {
            text: green
            selected_text: green_reverse
            description_text: yellow
        }
      }
      {
        name: history_menu
        only_buffer_difference: true
        marker: "? "
        type: {
            layout: list
            page_size: 10
        }
        style: {
            text: green
            selected_text: green_reverse
            description_text: yellow
        }
      }
      {
        name: help_menu
        only_buffer_difference: true
        marker: "? "
        type: {
            layout: description
            columns: 4
            col_width: 20   # Optional value. If missing all the screen width is used to calculate column width
            col_padding: 2
            selection_rows: 4
            description_rows: 10
        }
        style: {
            text: green
            selected_text: green_reverse
            description_text: yellow
        }
      }
      # Example of extra menus created using a nushell source
      # Use the source field to create a list of records that populates
      # the menu
      {
        name: commands_menu
        only_buffer_difference: false
        marker: "# "
        type: {
            layout: columnar
            columns: 4
            col_width: 20
            col_padding: 2
        }
        style: {
            text: green
            selected_text: green_reverse
            description_text: yellow
        }
        source: { |buffer, position|
            $nu.scope.commands
            | where command =~ $buffer
            | each { |it| {value: $it.command description: $it.usage} }
        }
      }
      {
        name: vars_menu
        only_buffer_difference: true
        marker: "# "
        type: {
            layout: list
            page_size: 10
        }
        style: {
            text: green
            selected_text: green_reverse
            description_text: yellow
        }
        source: { |buffer, position|
            $nu.scope.vars
            | where name =~ $buffer
            | sort-by name
            | each { |it| {value: $it.name description: $it.type} }
        }
      }
      {
        name: commands_with_description
        only_buffer_difference: true
        marker: "# "
        type: {
            layout: description
            columns: 4
            col_width: 20
            col_padding: 2
            selection_rows: 4
            description_rows: 10
        }
        style: {
            text: green
            selected_text: green_reverse
            description_text: yellow
        }
        source: { |buffer, position|
            $nu.scope.commands
            | where command =~ $buffer
            | each { |it| {value: $it.command description: $it.usage} }
        }
      }
  ]
  keybindings: [
    {
      name: completion_menu
      modifier: none
      keycode: tab
      mode: emacs # Options: emacs vi_normal vi_insert
      event: {
        until: [
          { send: menu name: completion_menu }
          { send: menunext }
        ]
      }
    }
    {
      name: completion_previous
      modifier: shift
      keycode: backtab
      mode: [emacs, vi_normal, vi_insert] # Note: You can add the same keybinding to all modes by using a list
      event: { send: menuprevious }
    }
    {
      name: history_menu
      modifier: control
      keycode: char_x
      mode: emacs
      event: {
        until: [
          { send: menu name: history_menu }
          { send: menupagenext }
        ]
      }
    }
    {
      name: history_previous
      modifier: control
      keycode: char_z
      mode: emacs
      event: {
        until: [
          { send: menupageprevious }
          { edit: undo }
        ]
      }
    }
    # Keybindings used to trigger the user defined menus
    {
      name: commands_menu
      modifier: control
      keycode: char_t
      mode: [emacs, vi_normal, vi_insert]
      event: { send: menu name: commands_menu }
    }
    {
      name: vars_menu
      modifier: control
      keycode: char_y
      mode: [emacs, vi_normal, vi_insert]
      event: { send: menu name: vars_menu }
    }
    {
      name: commands_with_description
      modifier: control
      keycode: char_u
      mode: [emacs, vi_normal, vi_insert]
      event: { send: menu name: commands_with_description }
    }
  ]
}
