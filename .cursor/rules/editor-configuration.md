# Editor Configuration Rules

## VS Code/Cursor Setup
- Both hosts use identical editor configuration via symlinks
- Cursor symlinks to VS Code settings and extensions
- Configuration files are in `modules/darwin/programs/vscode/`
- Cursor setup is in `modules/darwin/programs/cursor/default.nix`

## Key Configuration Files
- `modules/darwin/programs/vscode/config/user.nix`: Main settings
- `modules/darwin/programs/vscode/config/keybindings.nix`: Keybindings
- `modules/darwin/programs/cursor/default.nix`: Cursor symlink setup

## Development Workflow
- Use Cursor on Titan (work machine)
- Use VS Code on Thebe (personal machine)
- Both share the same configuration and extensions
- Changes to VS Code config affect both editors

## Extension Management
- Extensions are shared via symlink: `.cursor/extensions` → `.vscode/extensions`
- Extensions should be configured in home-manager modules
- Use `pkgs.vscode-extensions` for system-wide extensions

## File Associations
- `.nix` files: Use nix language support
- `.lua` files: Use Lua language support (for Hammerspoon config)
- `.toml` files: Use TOML language support
- `.yaml`/`.yml` files: Use YAML language support

## Terminal Integration
- Use WezTerm as the integrated terminal
- WezTerm config is in `modules/darwin/programs/wezterm/`
- Terminal font: TX-02, monospace
- Terminal font size: 14px
