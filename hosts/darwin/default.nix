{ config, pkgs, ... }:

{
    imports = [
    ../../modules/darwin/home-manager.nix
    ../../modules/darwin/packages.nix
    ];
}
