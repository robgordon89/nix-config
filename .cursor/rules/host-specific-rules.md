# Host-Specific Rules

## Titan (Work Machine)
- **Purpose**: Work development
- **Editor**: Cursor (symlinked from VS Code config)
- **Communication**: Slack instead of Beeper
- **Dock**: Uses VS Code → Cursor override
- **Environment**: Professional/work-focused

### Titan Configuration
- `extraConfig.dockPathOverrides`:
  - VS Code → Cursor
  - Beeper → Slack
- Uses `mailerlite` for home-manager integration
- Username: "robert"

## Thebe (Personal Machine)
- **Purpose**: Personal development
- **Editor**: VS Code
- **Communication**: Beeper
- **Dock**: Smaller icons (tilesize = 42)
- **Environment**: Personal/hobby-focused

### Thebe Configuration
- `extraConfig.dock.tilesize = 42`
- No dock path overrides
- Standard VS Code setup

## Shared Configuration
- Both hosts use the same:
  - VS Code/Cursor settings and keybindings
  - Extensions (via symlink)
  - Font configuration (TX-02, monospace)
  - Terminal setup (WezTerm)
  - Neovim configuration
  - Zsh configuration

## Configuration Patterns
- Use `extraConfig` for host-specific overrides
- Use `extraModules` for additional modules
- Keep shared config in `modules/shared/`
- Use `modules/darwin/` for macOS-specific config
