{ config
, lib
, pkgs
, ...
}:
let
  kubePlugin = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "kube";
    version = "1.0.0";
    src = pkgs.fetchFromGitHub {
      owner = "jonmosco";
      repo = "kube-tmux";
      rev = "master";
      sha256 = "sha256-PnPj2942Y+K4PF+GH6A6SJC0fkWU8/VjZdLuPlEYY7A=";
    };
  };
  floaxPlugin = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "floax";
    version = "1.0.0";
    src = pkgs.fetchFromGitHub {
      owner = "omerxx";
      repo = "tmux-floax";
      rev = "main";
      sha256 = "sha256-DOwn7XEg/L95YieUAyZU0FJ49vm2xKGUclm8WCKDizU=";
    };
  };
in
{
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    keyMode = "vi";
    baseIndex = 1;
    mouse = true;
    prefix = "C-Space";
    shell = "${pkgs.zsh}/bin/zsh";
    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
      copycat
      battery
      {
        plugin = kubePlugin;
        extraConfig = "";
      }
      {
        plugin = fuzzback;
        extraConfig = ''
          set -g @fuzzback-popup 1
          set -g @fuzzback-bind f
        '';
      }
      {
        plugin = floaxPlugin;
        extraConfig = ''
          set -g @floax-bind '-n C-f'
          set -g @floax-width '60%'
          set -g @floax-height '60%'
        '';
      }
    ];
    extraConfig = ''
      setw -g pane-base-index 1
      set-option -g renumber-windows on
      set-option -sa terminal-overrides ",xterm*:Tc"
      set-option -g default-command ${pkgs.zsh}/bin/zsh

      set-environment -g KUBE_TMUX_SYMBOL_ENABLE "false"

      set -g status-right-length 200
      set -g status-left-length 100
      set -g status-left ""
      set -g status-right "#{E:@catppuccin_status_directory}"
      set -agF status-right "#{E:@catppuccin_status_battery}"
      set -ag status-right "#{E:@catppuccin_status_kube}"

      set -g allow-passthrough on
      set -ga update-environment TERM
      set -ga update-environment TERM_PROGRAM
      bind -n C-g popup -d '#{pane_current_path}' -E -w 80% -h 80% lazygit
      bind -n C-e popup -Ed '#{pane_current_path}' -w85% -h85% yazi

      unbind -T copy-mode-vi MouseDragEnd1Pane

      set -g allow-passthrough on
      set -ga update-environment TERM
      set -ga update-environment TERM_PROGRAM

      bind -r g popup -d '#{pane_current_path}' -E -w 80% -h 80% lazygit
      bind -n C-e popup -Ed '#{pane_current_path}' -w85% -h85% yazi
      unbind -T copy-mode-vi MouseDragEnd1Pane

      # Split bindings
      bind - split-window -c "#{pane_current_path}"
      bind + split-window -h -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"

      run-shell ${pkgs.tmuxPlugins.battery}/share/tmux-plugins/battery/battery.tmux
    '';

  };
}
