{ pkgs, lib, ... }:
{
  # Create symlink for claude in ~/.local/bin for shortcuts support
  home.file.".local/bin/claude" = {
    source = "${pkgs.claude-code}/bin/claude";
  };
}
