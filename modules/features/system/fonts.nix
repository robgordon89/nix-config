{ ... }:
{
  flake.modules.darwin.fonts = { pkgs, ... }: {
    fonts.packages = with pkgs; [
      nerd-fonts.fira-code
      nerd-fonts.droid-sans-mono
      geist-font
    ];
  };
}
