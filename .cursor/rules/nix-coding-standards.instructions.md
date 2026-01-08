---
applyTo: "**/*"
---

# Nix Coding Standards

## General Principles
- Use declarative configuration over imperative
- Prefer home-manager modules over direct file creation
- Use overlays for package modifications
- Keep host-specific config minimal, use shared modules

## File Organization
- Host configurations in `hosts.nix`
- Shared modules in `modules/shared/`
- Darwin-specific modules in `modules/darwin/`
- Custom packages in `pkgs/`
- Overlays in `overlays/`

## Nix Language Conventions
- Use snake_case for variable names
- Use camelCase for attribute names
- Prefer `mkIf` and `mkDefault` for conditional config
- Use `lib.mkMerge` for combining configurations
- Use `lib.mkBefore`/`lib.mkAfter` for ordering

## Module Structure
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

## Package Management
- Use overlays for package modifications
- Prefer home-manager packages over system packages when possible
- Use `pkgs.writeShellScriptBin` for custom scripts
- Use `pkgs.symlinkJoin` for combining packages

## Configuration Patterns
- Use `extraConfig` for host-specific overrides
- Use `extraModules` for additional home-manager modules
- Use `mailerlite` for home-manager integration
- Use `dockPathOverrides` for application substitutions
