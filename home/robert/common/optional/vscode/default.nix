{ config, pkgs, ... }:
let
  extensions =
    (import (
      builtins.fetchGit {
        url = "https://github.com/nix-community/nix-vscode-extensions";
        ref = "refs/heads/master";
        rev = "2a84ca07753e3ec608c96ed2907606361979467a";
      }
    )).extensions.aarch64-darwin;
in
{
  programs.vscode = {
    enable = true;
    userSettings = import ./config/user.nix;
    keybindings = import ./config/keybindings.nix;
    extensions = (
      with extensions.vscode-marketplace;
      [
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
        ms-kubernetes-tools.vscode-kubernetes-tools
        kcl.kcl-vscode-extension
        wolfmah.ansible-vault-inline
        mechatroner.rainbow-csv
        subframe7536.custom-ui-style
      ]
    );
    mutableExtensionsDir = false;
  };
}