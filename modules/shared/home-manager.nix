{ ... }: {
  imports = [
    ./programs/bat
    ./programs/git
    ./programs/zsh
    ./programs/direnv.nix
    ./programs/fd.nix
    ./programs/k9s.nix
    ./programs/zoxide.nix
  ];
}
