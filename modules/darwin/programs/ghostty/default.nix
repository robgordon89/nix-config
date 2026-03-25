{ config, ... }:

{
  home.file."${config.xdg.configHome}/ghostty/config".text = ''
    # Font configuration
    font-family = TX-02
    font-size = 16
    font-feature = liga
    font-feature = clig
    adjust-cell-height = 2

    # Window appearance
    window-decoration = false
    window-padding-x = 8
    window-padding-y = 8
    confirm-close-surface = false

    # Color scheme - auto switch based on system appearance
    theme = dark:Black Metal (Mayhem),light:Builtin Solarized Light

    # Misc
    copy-on-select = clipboard
    mouse-hide-while-typing = true
    shell-integration = none
    working-directory = inherit

    # Split divider
    split-divider-color = #437487
    split-inherit-working-directory = true

    # Keybindings
    # Leader key equivalent (ctrl+a prefix) not directly supported in ghostty
    # but we can replicate individual bindings

    # Tab management
    keybind = cmd+t=new_tab
    keybind = ctrl+tab=next_tab
    keybind = ctrl+shift+tab=previous_tab
    keybind = ctrl+shift+w=close_surface

    # Pane/split management
    keybind = ctrl+shift+left_bracket=new_split:up
    keybind = ctrl+shift+right_bracket=new_split:right
    keybind = ctrl+shift+x=close_surface

    # Pane navigation
    keybind = cmd+h=goto_split:left
    keybind = cmd+j=goto_split:bottom
    keybind = cmd+k=goto_split:top
    keybind = cmd+l=goto_split:right

    # Font size
    keybind = ctrl+equal=increase_font_size:1
    keybind = ctrl+minus=decrease_font_size:1
    keybind = ctrl+zero=reset_font_size

    # Scrollback
    keybind = ctrl+shift+l=clear_screen

    # Word/line navigation (matching wezterm config)
    keybind = cmd+left=text:\x1bb
    keybind = cmd+right=text:\x1bf
    keybind = cmd+shift+left=text:\x01
    keybind = cmd+shift+right=text:\x05
    keybind = cmd+backspace=text:\x1bd
    keybind = cmd+shift+backspace=text:\x15
  '';
}
