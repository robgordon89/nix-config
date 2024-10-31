#############################################################
#
#  Ghost - Main Desktop
#  NixOS running on Ryzen 5 3600X, Radeon RX 5700 XT, 64GB RAM
#
###############################################################

{
  inputs,
  lib,
  configVars,
  configLib,
  pkgs,
  ...
}:
{
  imports = lib.flatten [
    (configLib.relativeToRoot "modules/darwin")
  ];

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = 1;
}
