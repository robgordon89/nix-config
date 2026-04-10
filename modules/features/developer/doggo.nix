{ ... }:
{
  flake.modules.homeManager.doggo = { pkgs, ... }: {
    home.packages = [
      pkgs.doggo
    ];

    programs.zsh = {
      shellAliases = {
        dig = "doggo";
      };
    };
  };
}
