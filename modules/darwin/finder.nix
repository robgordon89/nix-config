{ config, pkgs, lib, ... }:

let
  enabled = config.enabled;
  inherit (pkgs) stdenv dockutil;
in
{
  options = {
    enabled = lib.mkOption {
      type = lib.types.bool;
      default = stdenv.isDarwin;
    };
  };

  config = {
    # Set some sane defaults
    system.defaults = {
      # Set some finder defaults
      finder = {
        ShowPathbar = false;
        FXEnableExtensionChangeWarning = false;
        ShowStatusBar = false;
      };
    };
  };
}
