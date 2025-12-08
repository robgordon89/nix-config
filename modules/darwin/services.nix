{ pkgs, ... }:
{
  services.aerospace = {
    enable = false;
  };
  services.jankyborders = {
    enable = true;
    ax_focus = true;
    style = "sqaure";
    active_color = "0xFF437487"; # 437487
    inactive_color = "0xFF365D6C"; # 365D6C
    width = 10.0;
    hidpi = true;
    whitelist = [
      "Visual Studio Code"
      "Electron"
      "Cursor"
      "wezterm-gui"
    ];
  };
}
