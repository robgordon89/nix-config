{ config, pkgs, inputs, ... }:
{
  home.file = {
    # Use correct macOS paths for Application Support
    "Library/Application Support/Cursor/User/settings.json".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Library/Application Support/Code/User/settings.json";

    "Library/Application Support/Cursor/User/keybindings.json".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Library/Application Support/Code/User/keybindings.json";

    # Create a symlink for extensions as well
    ".cursor/extensions".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.vscode/extensions";

    # Add MCP configuration for Linear
    ".cursor/mcp.json".text = ''
      {
        "mcpServers": {
          "Linear": {
            "url": "https://obot.litehub.io/mcp-connect/default-linear-2ad8f8d8"
          },
          "Github": {
            "url": "https://obot.litehub.io/mcp-connect/default-github-391ae5a6"
          },
          "Sentry": {
            "url": "https://obot.litehub.io/mcp-connect/default-sentry-f0fce749r4tcg"
          },
          "Outline Search": {
            "url": "https://obot.litehub.io/mcp-connect/ms1959x5"
          },
          "Context7": {
            "url": "https://obot.litehub.io/mcp-connect/ms1lrhvc"
          }
        }
      }
    '';
  };
}
