{ inputs, pkgs, ... }:
{
  home = {
    stateVersion = "24.11";
    packages = with pkgs; [
      bob
      terraform
      poetry
      hugo
      ffmpeg-full
      flyctl
      minio-client
    ];
  };
  imports = [
    ../shared/programs/wezterm
    ../shared/programs/zsh
    ../shared/programs/git
    ../shared/programs/neovim
    ../shared/programs/fd
    ../shared/programs/hammerspoon
  ];
}
