#############################################################
#
#  Thebe - Personal MacBook
#
###############################################################

{ inputs
, lib
, config
, pkgs
, ...
}:

{
  imports = lib.flatten [
    (map lib.custom.relativeToRoot [
      #
      # ========== Required Configs ==========
      #
      "hosts/common/core"

      #
      # ========== Optional Configs ==========
      #
      "hosts/common/optional/finder.nix"
      "hosts/common/optional/fonts.nix"
      "hosts/common/optional/launchAgents.nix"
      "hosts/common/optional/preferences.nix"
      "hosts/common/optional/security.nix"
    ])
  ];

  #
  # ========== Host Specification ==========
  #
  hostSpec = {
    hostName = "thebe";
    isDarwin = true;
  };

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-darwin";

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = 5;
}
