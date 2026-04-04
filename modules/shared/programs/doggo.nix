{ pkgs, ... }: {
  home.packages = [
    pkgs.doggo
  ];

  programs.zsh = {
    shellAliases = {
      dig = "doggo";
    };
  };
}
