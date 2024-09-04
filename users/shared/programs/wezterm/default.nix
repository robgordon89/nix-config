{pkgs, ...}:

{
  home.file."${config.xdg.configHome}/wezterm" = {
    source = ./config;
    recursive = true;
  };
}
