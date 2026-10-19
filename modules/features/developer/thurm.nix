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
          material = "theme";
          padding_x = 4.0;
          padding_y = 8.0;
          confirm_close = false;
        };

        colors.theme = "light:iTerm2 Solarized Light,dark:Black Metal (Mayhem)";

        terminal.copy_on_select = true;

        updates.channel = "tip";

        keybindings = {
          "cmd+t" = "new_tab";
          "cmd+alt+right" = "next_tab";
          "cmd+alt+left" = "previous_tab";
          "ctrl+tab" = "next_tab";
          "ctrl+shift+tab" = "previous_tab";
          "cmd+shift+w" = "close_pane";

          "cmd+shift+left_bracket" = "split_down";
          "cmd+shift+right_bracket" = "split_right";
          "cmd+shift+x" = "close_pane";

          "cmd+h" = "focus_left";
          "cmd+j" = "focus_down";
          "cmd+k" = "focus_up";
          "cmd+l" = "focus_right";

          "cmd+shift+l" = "clear_screen";
        };

        # No send-text action: these send Ghostty's word/line navigation bytes through the CLI.
        commands = [
          {
            name = "Word left";
            exec = [
              "thurm"
              "send-keys"
              "M-b"
            ];
            key = "cmd+left";
          }
          {
            name = "Word right";
            exec = [
              "thurm"
              "send-keys"
              "M-f"
            ];
            key = "cmd+right";
          }
          {
            name = "Line start";
            exec = [
              "thurm"
              "send-keys"
              "C-a"
            ];
            key = "cmd+shift+left";
          }
          {
            name = "Line end";
            exec = [
              "thurm"
              "send-keys"
              "C-e"
            ];
            key = "cmd+shift+right";
          }
          {
            name = "Delete word";
            exec = [
              "thurm"
              "send-keys"
              "M-d"
            ];
            key = "cmd+backspace";
          }
          {
            name = "Delete line";
            exec = [
              "thurm"
              "send-keys"
              "C-u"
            ];
            key = "cmd+shift+backspace";
          }
        ];
      };
    };
  };
}
