# Nix Configuration Project

## Project Overview

This is a Nix/nix-darwin/home-manager configuration for two macOS hosts:
- **Titan**: Work machine (MailerLite SRE team)
- **Thebe**: Personal machine

## Host Differences

### Titan (Work)
- Slack instead of Beeper in dock
- MailerLite SRE packages and modules
- Claude Code with Vertex AI integration
- SSH username: "robert"

### Thebe (Personal)
- Beeper for communication
- Smaller dock icons (tilesize = 42)
- Custom SSH hosts

### Shared Configuration
- Both hosts use VS Code as the editor
- Same VS Code settings, keybindings, and extensions
- Same font configuration (TX-02, monospace)
- Same terminal setup (WezTerm)
- Same Neovim and Zsh configuration

## Project Structure

- `hosts.nix`: Main host configuration for titan and thebe
- `flake.nix`: Flake configuration
- `lib/mkHost.nix`: Host builder
- `modules/shared/`: Configuration shared by both hosts
- `modules/darwin/`: macOS-specific modules
- `overlays/`: Package overlays and modifications
- `pkgs/`: Custom packages
- `hosts/`: Host-specific overrides (minimal)

## Key Files

- VS Code settings: `modules/darwin/programs/vscode/config/user.nix`
- VS Code keybindings: `modules/darwin/programs/vscode/config/keybindings.nix`
- VS Code extensions: `modules/darwin/programs/vscode/default.nix`
- Claude Code settings: `modules/shared/programs/claude-code.nix`
- Host configuration: `hosts.nix`
- Zsh configuration: `modules/shared/programs/zsh/default.nix`

## Development Workflow

### Building and Testing
- Use `task build` to build the configuration and switch
- Use `task update` to update nix flakes
- Use `task update-mailerlite` for just updating mailerlite flake
- Use `nix flake check` to validate the flake

### Configuration Changes
1. Edit the appropriate module file
2. Test with `nix flake check`
3. Build with `task build`
4. Restart affected services if needed

### Adding New Packages
- System packages: Add to `modules/darwin/packages.nix`
- Home Manager packages: Add to `modules/shared/packages.nix`
- Custom packages to build: Add to `pkgs/` directory
- Overlays: Add to `overlays/` directory

### Adding New Programs
- VS Code extensions: Add to `modules/darwin/programs/vscode/default.nix`
- Neovim plugins: Add to `modules/shared/programs/neovim/default.nix`
- Zsh plugins: Add to `modules/shared/programs/zsh/default.nix`
- Custom programs: Create new module in appropriate directory

## Nix Coding Standards

### General Principles
- Use declarative configuration over imperative
- Prefer home-manager modules over direct file creation
- Use overlays for package modifications
- Keep host-specific config minimal, use shared modules

### Nix Language Conventions
- Use snake_case for variable names
- Use camelCase for attribute names
- Prefer `mkIf` and `mkDefault` for conditional config
- Use `lib.mkMerge` for combining configurations
- Use `lib.mkBefore`/`lib.mkAfter` for ordering

### Configuration Patterns
- Use `extraConfig` for host-specific overrides
- Use `extraModules` for additional home-manager modules
- Use `dockPathOverrides` for application substitutions in dock

### Module Structure
```nix
{ config, lib, pkgs, ... }:
{
  options = {
    # Define options here
  };

  config = lib.mkIf config.enable {
    # Implementation here
  };
}
```

## Debugging

### Common Issues
- **Git**: Make sure all files are staged (or you will get errors)
- **Package conflicts**: Check overlays and package priorities
- **Service failures**: Check `modules/darwin/services.nix`
- **Font issues**: Check `modules/darwin/fonts.nix`

### Debugging Commands
- `nix flake show` - Show flake structure
- `nix eval .#darwinConfigurations.titan.config` - Evaluate config
- `task build` - Build and switch
