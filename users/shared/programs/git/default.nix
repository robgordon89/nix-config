{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    package = pkgs.git;
    userName = "Robert Gordon";
    userEmail = "rob@ruled.io";
    signing = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEJOD+xGS8a9Q2Dyyah+jH6caM2n4XaJNKRvmbo7NqaY";
      signByDefault = true;
    };
    extraConfig = import ./config/extra.nix;
    ignores = import ./config/ignores.nix;
    aliases = import ./config/aliases.nix;
  };
}
