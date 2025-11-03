# Development Workflow Rules

## Common Tasks

### Building and Testing
- Use `task build` to build the configuration and switch
- Use `task update` to update nix flakes
- Use `task update-mailerlite` for just updating mailerlite flake (easier when working on it)
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

## Debugging

### Common Issues
- **Git**: Make sure all files are staged (or you will get errors)
- **Symlink issues**: Check Cursor/VS Code symlink setup
- **Package conflicts**: Check overlays and package priorities
- **Service failures**: Check `modules/darwin/services.nix`
- **Font issues**: Check `modules/darwin/fonts.nix`

### Debugging Commands
- `nix flake show` - Show flake structure
- `nix eval .#darwinConfigurations.titan.config` - Evaluate config
- `task build` - Build and switch

## File Organization

### When to Use Each Directory
- `modules/shared/`: Configuration used by both hosts
- `modules/darwin/`: macOS-specific configuration
- `overlays/`: Package modifications and additions
- `pkgs/`: Custom packages and scripts
- `hosts/`: Host-specific overrides (minimal)

### Module Structure
- Each module should have a `default.nix`
- Use `options` and `config` sections
- Use `lib.mkIf` for conditional configuration
- Use `lib.mkMerge` for combining configs
