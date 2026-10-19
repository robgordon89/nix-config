{ inputs, ... }:
{
  # Thurm.app has no cask: install the tip DMG once, Sparkle keeps it on the tip channel.
  flake.modules.homeManager.thurm = {
    imports = [ inputs.thurm.homeManagerModules.default ];

    programs.thurm = {
      enable = true;
      settings = {
        font = {
          family = "TX-02";
          size = 16.0;
          line_height = 1.1;
        };

        window = {
          padding_x = 4.0;
          padding_y = 8.0;
          confirm_close = false;
        };

        colors.theme = "light:iTerm2 Solarized Light,dark:Black Metal (Mayhem)";

        terminal.copy_on_select = true;

        updates.channel = "tip";

        # The macOS app doesn't apply [keybindings] yet; these take effect once it does.
        keybindings = {
          "cmd+t" = "new_tab";
          "ctrl+tab" = "select_next_tab";
          "ctrl+shift+tab" = "select_previous_tab";
          "ctrl+shift+w" = "close_pane";

          "ctrl+shift+left_bracket" = "split_down";
          "ctrl+shift+right_bracket" = "split_right";
          "ctrl+shift+x" = "close_pane";

          "cmd+h" = "focus_left";
          "cmd+j" = "focus_down";
          "cmd+k" = "focus_up";
          "cmd+l" = "focus_right";

          "ctrl+equal" = "increase_font_size";
          "ctrl+minus" = "decrease_font_size";
          "ctrl+0" = "reset_font_size";

          "ctrl+shift+l" = "clear_screen";
        };
      };
    };
  };
}
