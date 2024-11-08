{ config
, inputs
, lib
, pkgs
, outputs
, configLib
, ...
}:
{
  imports = lib.flatten [
    inputs.krewfile.homeManagerModules.krewfile
    (configLib.scanPaths ./.)
  ];

  home = {
    username = lib.mkDefault "robert";
    homeDirectory = lib.mkDefault "/Users/${config.home.username}";
    stateVersion = lib.mkDefault "23.05";
    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/scripts/talon_scripts"
    ];

  };
  home.packages = builtins.attrValues {
    inherit (pkgs)
      restic
      eza
      statix
      ansible-lint
      devenv
      nixpkgs-fmt
      bob
      terraform
      poetry
      hugo
      ffmpeg-full
      flyctl
      minio-client
      go-task
      ;
    inherit (pkgs.stable)
      kcl-cli
      ;
  };

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  programs = {
    home-manager.enable = true;
  };
}
