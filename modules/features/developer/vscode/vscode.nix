{ ... }:
{
  flake.modules.darwin.vscode = {
    homebrew.casks = [{ name = "visual-studio-code"; greedy = true; }];
  };

  flake.modules.homeManager.vscode = { config, pkgs, inputs, lib, ... }:
    let
      is_work_host = config.meta.work.enable;

      # Workaround: Anthropic periodically re-publishes the same claude-code
      # extension version to the VS Marketplace with different bytes, so the
      # hash pinned in nix4vscode's generated data goes stale and the build
      # fails with a fixed-output hash mismatch. Override the vsix with the
      # currently-served hash. Guarded on version so it self-disables once
      # nix4vscode's data moves past this version.
      # To refresh after another mismatch, run:
      #   nix store prefetch-file --name anthropic-claude-code.vsix \
      #     "https://anthropic.gallery.vsassets.io/_apis/public/gallery/publisher/anthropic/extension/claude-code/<version>/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage?"
      claudeCodeVsixPin = {
        version = "2.1.208";
        hash = "sha256-+qFBbGNNxAAQMBCeHdzQDbczt2Pv3Khchv6TYqivDPM=";
      };
      claudeCodeVsix = pkgs.fetchurl {
        name = "anthropic-claude-code.vsix";
        url = "https://anthropic.gallery.vsassets.io/_apis/public/gallery/publisher/anthropic/extension/claude-code/${claudeCodeVsixPin.version}/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage?";
        inherit (claudeCodeVsixPin) hash;
      };
      fixClaudeCodeVsix = map (ext:
        if (ext.vscodeExtUniqueId or "") == "anthropic.claude-code"
        && (ext.version or "") == claudeCodeVsixPin.version
        then ext.overrideAttrs (_: { src = claudeCodeVsix; })
        else ext
      );
    in
    {
      programs.vscode = {
        # We dont use the package from nixpkgs becuase it doesnt allow mods
        # See homebrew.nix where we install vscode from homebrew
        enable = true;
        profiles.default = {
          userSettings = import ./_config/user.nix { inherit lib; };
          keybindings = import ./_config/keybindings.nix {
            inherit lib;
            useClaudeSidebar = is_work_host;
          };
          enableUpdateCheck = false;
          enableExtensionUpdateCheck = false;
          extensions = fixClaudeCodeVsix (pkgs.nix4vscode.forVscode (
            [
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
              "opentofu.vscode-opentofu"
            ]
            ++ lib.optionals is_work_host [ "anthropic.claude-code" ]
            ++ lib.optionals (!is_work_host) [ "github.copilot-chat" ]
          ));
        };
        mutableExtensionsDir = false;
      };

      # Create mcp.json directly since userMcp is not available in home-manager release-25.05
      home.file."Library/Application Support/Code/User/mcp.json" = {
        text = builtins.toJSON (import ./_config/mcp.nix);
      };
    };
}
