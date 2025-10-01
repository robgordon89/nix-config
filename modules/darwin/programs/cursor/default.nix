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
          "linear": {
            "command": "npx",
            "args": ["-y", "mcp-remote", "https://mcp.linear.app/sse"]
          }
        }
      }
    '';
  };
}
