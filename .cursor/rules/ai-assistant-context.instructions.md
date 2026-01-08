---
applyTo: "**/*"
---

# AI Assistant Context

## Project Overview
This is a Nix/nix-darwin/homemanger configuration for two macOS hosts:
- **Titan**: Work machine using Cursor editor
- **Thebe**: Personal machine using VS Code

## Key Context for AI Assistants

### Host Differences
- **Titan (Work)**: Uses Cursor (symlinked from VS Code), Slack instead of Beeper
- **Thebe (Personal)**: Uses VS Code, Beeper, smaller dock icons

### Editor Configuration
- Both hosts share identical editor settings via symlinks
- Cursor configuration: `modules/darwin/programs/cursor/default.nix`
- VS Code configuration: `modules/darwin/programs/vscode/`
- Settings file: `modules/darwin/programs/vscode/config/user.nix`
- Keybindings: `modules/darwin/programs/vscode/config/keybindings.nix`

### Project Structure
- `hosts.nix`: Main host configuration
- `modules/shared/`: Configuration for both hosts
- `modules/darwin/`: macOS-specific modules
- `overlays/`: Package modifications
- `pkgs/`: Custom packages

### Common Patterns
- Use `extraConfig` for host-specific overrides
- Use `extraModules` for additional home-manager modules
- Use `mailerlite` for home-manager integration
- Use `dockPathOverrides` for application substitutions

### Important Files
- `flake.nix`: Main flake configuration
- `hosts.nix`: Host definitions
- `modules/darwin/programs/cursor/default.nix`: Cursor setup
- `modules/darwin/programs/vscode/config/user.nix`: Editor settings

## When Helping
- Always consider which host the change affects
- Remember the editor differences (Cursor vs VS Code)
- Use appropriate module directories (shared vs darwin-specific)
- Follow the existing patterns in the codebase
- Consider symlink implications for editor configuration
