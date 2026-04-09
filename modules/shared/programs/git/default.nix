{ pkgs, hostConfig, ... }:
{
  programs.git = {
    enable = true;
    package = pkgs.git;
    signing = {
      key = hostConfig.sshPublicKey;
      signByDefault = true;
    };
    ignores = import ./config/ignores.nix;
    settings =
      import ./config/extra.nix
      // {
        user = {
          name = hostConfig.fullName;
          email = hostConfig.email;
        };
        alias = import ./config/aliases.nix;
      };
  };
}
