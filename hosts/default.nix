{ config, lib, platform, hostname, pkgs, ... }:

let isWork = if (lib.strings.toLower hostname == "bobs-macbook-air") then true else false;
in
{
  imports = [
    ../modules/darwin/home-manager.nix
    ../modules/darwin/packages.nix
  ] ++ lib.optional (isWork) ../_mixins/work;
}
