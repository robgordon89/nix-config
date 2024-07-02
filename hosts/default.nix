{ config, lib, platform, isWork, pkgs, ... }:

{
  imports = [
    ../modules/darwin/home-manager.nix
    ../modules/darwin/packages.nix
  ] ++ lib.optional (isWork) ../_mixins/work;
}
