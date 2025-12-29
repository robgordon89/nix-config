{ ... }:
{
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [
      "--cmd cd" # replace cd with z and zi (via cdi)
    ];
  };
}
