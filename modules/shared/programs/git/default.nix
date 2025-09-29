{ pkgs, hostConfig, ... }:
{
  programs.git = {
    enable = true;
    package = pkgs.git;
    userName = hostConfig.fullName;
    userEmail = hostConfig.email;
    signing = {
      key = hostConfig.sshPublicKey;
      signByDefault = true;
    };
    extraConfig = import ./config/extra.nix;
    ignores = import ./config/ignores.nix;
    aliases = import ./config/aliases.nix;
  };
}
