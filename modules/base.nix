{ config, ... }:
let
  inherit (config.flake.modules) darwin homeManager generic;
in
{
  flake.modules.darwin.base = {
    imports = [
      generic.meta
      darwin.overlays
      darwin.homeManager
      darwin.nixHomebrew

      # system category
      darwin.system
      darwin.dock
      darwin.finder
      darwin.fonts
      darwin.homebrew
      darwin.preferences
      darwin.security
      darwin.services
      darwin.logiOptions # cask: logi-options+
      darwin.cloudflareWarp # cask: cloudflare-warp

      # developer category (darwin-side pieces)
      darwin.onePassword # cask: 1password
      darwin.ghostty # cask: ghostty
      darwin.vscode # cask: visual-studio-code
      darwin.tableplus # cask: tableplus
      darwin.tablepro # cask: tablepro
      darwin.tailscale # cask: tailscale-app
      darwin.medis # cask: medis
      darwin.syntaxHighlight # cask: syntax-highlight

      # desktop category
      darwin.brave # cask: brave-browser
      darwin.hammerspoon # cask: hammerspoon
      darwin.cleanshot # cask: cleanshot
      darwin.swiftbar # cask: swiftbar
    ];

    home-manager.sharedModules = [
      generic.meta

      # system category
      homeManager.hmWorkarounds

      # developer category
      homeManager.packagesCore
      homeManager.packagesLanguages
      homeManager.packagesOps
      homeManager.onePassword
      homeManager.ghostty
      homeManager.vscode
      homeManager.git
      homeManager.gh
      homeManager.direnv
      homeManager.claudeCode
      homeManager.zsh
      homeManager.neovim
      homeManager.zoxide
      homeManager.fd
      homeManager.doggo
      homeManager.k9s
      homeManager.ssh

      # desktop category
      homeManager.hammerspoon
    ];
  };
}
