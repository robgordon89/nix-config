{ config, pkgs, lib, ... }:

{
  # Allow the user to use sudo with Touch ID
  security.pam.enableSudoTouchIdAuth = true;
}
