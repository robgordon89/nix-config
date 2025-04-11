{ pkgs, ... }:
{
  services.karabiner-elements = {
    enable = false;
    # Use stable see https://github.com/LnL7/nix-darwin/issues/1041
    package = pkgs.stable.karabiner-elements;
  };

  # services.ollama = {
  #   enable = false;
  #   # Optional: load models on startup
  #   loadModels = [ "deepseek-r1" ];
  # };

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
      "wezterm-gui"
    ];
  };

  services.aerospace = {
    enable = false;
    settings = {
      gaps = {
        inner.horizontal = 8;
        inner.vertical = 8;

        outer.left = 8;
        outer.bottom = 0;
        outer.top = 0;
        outer.right = 8;
      };
      mode.main.binding = {
        alt-h = "focus left";
        alt-j = "focus down";
        alt-k = "focus up";
        alt-l = "focus right";
      };
    };
  };
}
