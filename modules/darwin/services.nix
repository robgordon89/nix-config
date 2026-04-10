{ pkgs, ... }:
{
  services.jankyborders = {
    enable = true;
    ax_focus = true;
    style = "square";
    active_color = "0xFF437487"; # 437487
    inactive_color = "0xFF365D6C"; # 365D6C
    width = 10.0;
    hidpi = true;
    whitelist = [
      "Code"
      "Electron"
      "Cursor"
      "wezterm-gui"
      "ghostty"
      "Brave Browser"
      "Slack"
    ];
  };
}
