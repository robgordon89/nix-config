{ ... }:
{
  flake.modules.darwin.vscode = {
    homebrew.casks = [ { name = "visual-studio-code"; greedy = true; } ];
  };

  flake.modules.homeManager.vscode = { config, pkgs, inputs, lib, ... }: {
    programs.vscode = {
      # We dont use the package from nixpkgs becuase it doesnt allow mods
      # See homebrew.nix where we install vscode from homebrew
      enable = true;
      profiles.default = {
        userSettings = import ./_config/user.nix { inherit lib; };
        keybindings = import ./_config/keybindings.nix { inherit lib; };
        enableUpdateCheck = false;
        enableExtensionUpdateCheck = false;
        extensions = pkgs.nix4vscode.forVscode ([
          "adamhartford.vscode-base64"
          "amiralizadeh9480.laravel-extra-intellisense"
          "arrterian.nix-env-selector"
          "bmewburn.vscode-intelephense-client"
          "codingyu.laravel-goto-view"
          "dhoeric.ansible-vault"
          "editorconfig.editorconfig"
          "esbenp.prettier-vscode"
          "github.vscode-github-actions"
          "glitchbl.laravel-create-view"
          "golang.go"
          "hashicorp.terraform"
          "ihunte.laravel-blade-wrapper"
          "jnoortheen.nix-ide"
          "junstyle.php-cs-fixer"
          "kcl.kcl-vscode-extension"
          "mechatroner.rainbow-csv"
          "mikestead.dotenv"
          # Use a older version compatible with VSCode 1.96.2
          "ms-kubernetes-tools.vscode-kubernetes-tools.1.3.13"
          "ms-python.black-formatter"
          "ms-python.debugpy"
          "ms-python.python"
          "ms-python.vscode-pylance"
          "naoray.laravel-goto-components"
          "nickgo.cuelang"
          "onecentlin.laravel-blade"
          "onecentlin.laravel-extension-pack"
          "onecentlin.laravel5-snippets"
          "pgl.laravel-jump-controller"
          "redhat.ansible"
          "redhat.vscode-yaml"
          "ryannaddy.laravel-artisan"
          "shufo.vscode-blade-formatter"
          "subframe7536.custom-ui-style"
          "tintedtheming.base16-tinted-themes"
          "wolfmah.ansible-vault-inline"
          "tamasfe.even-better-toml"
          "pomdtr.excalidraw-editor"
          "anthropic.claude-code"
          "github.copilot-chat"
        ]);
      };
      mutableExtensionsDir = false;
    };

    # Create mcp.json directly since userMcp is not available in home-manager release-25.05
    home.file."Library/Application Support/Code/User/mcp.json" = {
      text = builtins.toJSON (import ./_config/mcp.nix);
    };
  };
}
