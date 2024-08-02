{pkgs, ...}: {
  home.file.".hammerspoon" = {
    source = ./config;
    recursive = true;
  };
}
