{ config, pkgs, ... }:
let
  extensions =
    (import (builtins.fetchGit {
      url = "https://github.com/nix-community/nix-vscode-extensions";
      ref = "refs/heads/master";
      rev = "06e54246d3c91e3d5015027516100b58fc3ec986";
    })).extensions.aarch64-darwin;
in
{
  programs.vscode = {
    enable = true;
    userSettings = import ./config/user.nix;
    extensions = (with extensions.vscode-marketplace; [
      adamhartford.vscode-base64
      amiralizadeh9480.laravel-extra-intellisense
      bmewburn.vscode-intelephense-client
      codingyu.laravel-goto-view
      dhoeric.ansible-vault
      editorconfig.editorconfig
      esbenp.prettier-vscode
      github.copilot
      github.copilot-chat
      glitchbl.laravel-create-view
      golang.go
      hashicorp.terraform
      ihunte.laravel-blade-wrapper
      jnoortheen.nix-ide
      junstyle.php-cs-fixer
      mikestead.dotenv
      ms-python.black-formatter
      ms-python.debugpy
      ms-python.python
      ms-python.vscode-pylance
      naoray.laravel-goto-components
      onecentlin.laravel-blade
      onecentlin.laravel-extension-pack
      onecentlin.laravel5-snippets
      pgl.laravel-jump-controller
      redhat.ansible
      redhat.vscode-yaml
      ryannaddy.laravel-artisan
      shufo.vscode-blade-formatter
    ]);
    # mutableExtensionsDir = false;
    # extensions = with pkgs.vscode-extensions; [
    #   jnoortheen.nix-ide
    # ];
  };
}
