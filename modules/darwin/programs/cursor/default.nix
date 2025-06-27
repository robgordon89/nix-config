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
          "victoriametrics": {
            "command": "docker",
            "args": [
              "run",
              "-i",
              "--rm",
              "-e",
              "VM_INSTANCE_ENTRYPOINT",
              "-e",
              "VM_INSTANCE_TYPE",
              "ghcr.io/victoriametrics-community/mcp-victoriametrics"
            ],
            "env": {
              "VM_INSTANCE_ENTRYPOINT": "http://host.docker.internal:8481",
              "VM_INSTANCE_TYPE": "cluster"
            }
          },
          "victorialogs": {
            "command": "docker",
            "args": [
              "run",
              "-i",
              "--rm",
              "--platform",
              "linux/amd64",
              "-e",
              "VL_INSTANCE_ENTRYPOINT",
              "ghcr.io/victoriametrics-community/mcp-victorialogs"
            ],
            "env": {
              "VL_INSTANCE_ENTRYPOINT": "http://host.docker.internal:9428"
            }
          },
          "temposerver": {
            "command": "docker",
            "args": ["run", "--rm", "-i", "-e", "TEMPO_URL=http://host.docker.internal:3200", "tempo-mcp-server"],
            "disabled": false,
            "autoApprove": ["tempo_query"]
          }
        }
      }
    '';
  };
}
