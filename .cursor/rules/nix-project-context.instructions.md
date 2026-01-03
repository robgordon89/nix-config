---
applyTo: "**/*"
---

# Nix Project Context

## Host Configuration
- **Titan**: Work machine - uses Cursor instead of VS Code, Slack instead of Beeper
- **Thebe**: Personal machine - uses VS Code, Beeper

## Editor Setup
- Both hosts share the same VS Code/Cursor configuration via symlinks
- Cursor configuration is in `modules/darwin/programs/cursor/default.nix`
- VS Code configuration is in `modules/darwin/programs/vscode/`
- Cursor symlinks to VS Code settings and extensions

## Project Structure
- `hosts.nix`: Main host configuration for titan and thebe
- `modules/darwin/`: macOS-specific modules
- `modules/shared/`: Shared modules for both hosts / platforms
- `overlays/`: Package overlays and modifications
- `pkgs/`: Custom packages

## Key Files
- VS Code settings: `modules/darwin/programs/vscode/config/user.nix`
- VS Code keybindings: `modules/darwin/programs/vscode/config/keybindings.nix`
- Cursor setup: `modules/darwin/programs/cursor/default.nix`
- Host configuration: `hosts.nix`
- Flake configuration: `flake.nix`
