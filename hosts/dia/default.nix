{ inputs
, lib
, configVars
, configLib
, pkgs
, ...
}:

{
  nix.package = pkgs.nixVersions.latest;

  # Read the changelog before changing this value
  system.stateVersion = "24.05";

  # Set up nix for flakes
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  environment.packages = with pkgs; [
    vim
    git
  ];

  # imports = lib.flatten [
  #   # (map configLib.relativeToRoot [
  #   #   "hosts/common/core"
  #   # ])
  # ];

}
