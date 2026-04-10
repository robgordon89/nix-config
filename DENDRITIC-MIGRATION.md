# Dendritic Migration Plan

## Context

Migrate nix-config from traditional flake pattern (manual imports, specialArgs/hostConfig, mkHost builder) to the Dendritic pattern (flake-parts + import-tree, feature-based modules, meta options). This prepares the config for future Linux HM hosts and potential NixOS.

**Decisions made:**
- Minimal Dendritic: flat features, no tiers, no factory, no class tags
- Feature-based: each feature = one file (or directory with `_config/` for data files)
- Shared base module: `base.nix` composes all features, hosts import base + overrides
- Mailerlite wrapped as feature module
- Manual flake.nix (no flake-file)
- `meta.nix` generic module replaces hostConfig/specialArgs

## Target Structure

```
flake.nix                                    # inputs + mkFlake + import-tree ./modules

modules/
  flake-parts.nix                            # enables flake.modules, sets systems
  darwin-configurations.nix                  # wiring: configurations.darwin -> flake output
  meta.nix                                   # generic module: meta.username, meta.email, etc.
  overlays.nix                               # registers overlays via nixpkgs.overlays
  home-manager.nix                           # wires HM darwinModule + user setup
  nix-homebrew.nix                           # wires nix-homebrew darwinModule
  per-system.nix                             # formatter, devShells, checks via perSystem
  base.nix                                   # composes all shared features for hosts

  features/
    dock.nix                                 # darwin.dock
    finder.nix                               # darwin.finder
    fonts.nix                                # darwin.fonts
    homebrew.nix                             # darwin.homebrew
    launch-agents.nix                        # darwin.launchAgents
    preferences.nix                          # darwin.preferences
    security.nix                             # darwin.security
    services.nix                             # darwin.services
    system.nix                               # darwin.system
    vscode/vscode.nix + _config/             # darwin.vscode + homeManager.vscode
    ghostty.nix                              # darwin.ghostty + homeManager.ghostty
    1password.nix                            # darwin.1password + homeManager.1password
    brave.nix                                # darwin.brave
    hammerspoon/hammerspoon.nix + _config/   # darwin.hammerspoon + homeManager.hammerspoon
    packages.nix                             # homeManager.packages
    git.nix                                  # homeManager.git
    zsh/zsh.nix + _config/                   # homeManager.zsh
    neovim/neovim.nix + _nvim/              # homeManager.neovim
    claude-code.nix                          # homeManager.claudeCode
    direnv.nix                               # homeManager.direnv
    doggo.nix                                # homeManager.doggo
    fd.nix                                   # homeManager.fd
    gh.nix                                   # homeManager.gh
    k9s.nix                                  # homeManager.k9s
    ssh.nix                                  # homeManager.ssh
    zoxide.nix                               # homeManager.zoxide
    mailerlite.nix                           # darwin.mailerlite + homeManager.mailerlite

  hosts/
    titan.nix                                # darwin.base + darwin.mailerlite + overrides
    thebe.nix                                # darwin.base (no extras)

overlays/                                    # kept as-is, referenced by overlays.nix
pkgs/                                        # kept as-is
```

**import-tree convention**: directories prefixed with `_` are ignored by import-tree. This is used for config data files (e.g., `_config/user.nix`) that should be `import`ed explicitly, not auto-loaded as flake-parts modules.

## Phase 0: Commit Cleanup

Commit the existing uncommitted changes (AUDIT.md fixes) as a separate commit on main before starting the migration.

## Phase 1: Create Branch + Add Inputs

**Branch**: `dendritic-migration`

**File**: `flake.nix` -- add two new inputs:
```nix
flake-parts.url = "github:hercules-ci/flake-parts";
import-tree.url = "github:vic/import-tree";
```

Run `nix flake update flake-parts import-tree` to lock them.

## Phase 2: Infrastructure Modules (create all before touching flake.nix)

### 2a. `modules/flake-parts.nix`
```nix
{ inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];
  systems = [ "aarch64-darwin" ];
}
```
Enables `flake.modules.<class>.<name>` options and sets target systems.

### 2b. `modules/darwin-configurations.nix`
Wires `configurations.darwin` option -> `flake.darwinConfigurations` output.
```nix
{ lib, flake-parts-lib, config, inputs, ... }:
{
  options = {
    configurations.darwin = lib.mkOption {
      type = lib.types.lazyAttrsOf (lib.types.submodule {
        options = {
          system = lib.mkOption { type = lib.types.str; default = "aarch64-darwin"; };
          module = lib.mkOption { type = lib.types.deferredModule; default = { }; };
        };
      });
      default = { };
    };
    flake = flake-parts-lib.mkSubmoduleOptions {
      darwinConfigurations = lib.mkOption {
        type = lib.types.lazyAttrsOf lib.types.raw;
        default = { };
      };
    };
  };

  config.flake.darwinConfigurations = lib.mapAttrs (_: cfg:
    inputs.nix-darwin.lib.darwinSystem {
      inherit (cfg) system;
      modules = [ cfg.module ];
    }
  ) config.configurations.darwin;
}
```

### 2c. `modules/meta.nix`
Generic module replacing hostConfig. Imported into both darwin and HM contexts.

Current hostConfig fields used across 11 files:
- `username` ("robert") -- dock, launchAgents, home-manager, hosts/darwin, ssh
- `email` ("rob@ruled.io") -- git
- `firstName` ("Robert"), `lastName` ("Gordon"), `fullName` -- git
- `sshPublicKey` (hardcoded ed25519 key string) -- git signing
- `platform` ("aarch64-darwin") -- hosts/darwin (handled by configurations.darwin.system)
- `dockPathOverrides` ({}) -- dock
- `dock` ({}) -- dock host-specific overrides
- `extraHomeManagerPackages` ([]) -- packages
- `ssh` ({}) -- ssh module (opt-in, enabled by mailerlite)
- `claudeCode` ({}) -- vscode settings (optional)

```nix
{ ... }:
{
  flake.modules.generic.meta = { lib, ... }: {
    options.meta = {
      username = lib.mkOption { type = lib.types.str; default = "robert"; };
      firstName = lib.mkOption { type = lib.types.str; default = "Robert"; };
      lastName = lib.mkOption { type = lib.types.str; default = "Gordon"; };
      fullName = lib.mkOption { type = lib.types.str; default = "Robert Gordon"; };
      email = lib.mkOption { type = lib.types.str; default = "rob@ruled.io"; };
      sshPublicKey = lib.mkOption {
        type = lib.types.str;
        default = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEJOD+xGS8a9Q2Dyyah+jH6caM2n4XaJNKRvmbo7NqaY";
      };
      dockPathOverrides = lib.mkOption { type = lib.types.attrsOf lib.types.str; default = { }; };
      dock = lib.mkOption { type = lib.types.attrs; default = { }; };
      extraHomeManagerPackages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [ ];
      };
    };
  };
}
```
**Note**: `platform` is no longer needed in meta -- handled by `configurations.darwin.<host>.system`. The `ssh` and `claudeCode` hostConfig fields come from the mailerlite module and will be handled by its own options within the HM context.

### 2d. `modules/overlays.nix`
```nix
{ inputs, ... }:
{
  flake.modules.darwin.overlays = {
    nixpkgs.overlays = builtins.attrValues (
      import ../overlays { inherit inputs; }
    );
    nixpkgs.config.allowUnfree = true;
  };
}
```
Keeps existing `overlays/` directory and auto-discovery. Just applies them via `nixpkgs.overlays` instead of `import nixpkgs { overlays = ...; }`.

### 2e. `modules/home-manager.nix`
Wires home-manager darwinModule and sets up user.
```nix
{ inputs, ... }:
{
  flake.modules.darwin.homeManager = { config, ... }: {
    imports = [ inputs.home-manager.darwinModules.home-manager ];
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
    };
    home-manager.users.${config.meta.username} = {
      programs.home-manager.enable = true;
      home.stateVersion = "24.05";
    };
  };
}
```
**Note**: This module depends on `meta.username` being available. Hosts must import `generic.meta` into their darwin modules list.

### 2f. `modules/nix-homebrew.nix`
```nix
{ inputs, ... }:
{
  flake.modules.darwin.nixHomebrew = { config, ... }: {
    imports = [ inputs.nix-homebrew.darwinModules.nix-homebrew ];
    nix-homebrew = {
      enable = true;
      user = config.meta.username;
      taps = {
        "homebrew/homebrew-core" = inputs.homebrew-core;
        "homebrew/homebrew-cask" = inputs.homebrew-cask;
      };
      mutableTaps = false;
    };
  };
}
```

### 2g. `modules/per-system.nix`
```nix
{ inputs, ... }:
{
  perSystem = { pkgs, system, ... }: {
    formatter = pkgs.nixfmt;
    devShells.default = pkgs.mkShell {
      packages = with pkgs; [ nixfmt nil go-task ];
      shellHook = (inputs.lefthook.lib.${system}.mkShellHook {
        src = inputs.self;
        hooks.pre-commit.commands.nixfmt = {
          run = "nixfmt --check {staged_files}";
          glob = "*.nix";
        };
      });
    };
    checks.lefthook = inputs.lefthook.lib.${system}.run {
      src = inputs.self;
      hooks.pre-commit.commands.nixfmt = {
        run = "nixfmt --check {staged_files}";
        glob = "*.nix";
      };
    };
  };
}
```

## Phase 3: Feature Modules

Migrate each current module to a feature file. Pattern for each:

**Darwin-only feature** (e.g., dock.nix):
```nix
{ ... }:
{
  flake.modules.darwin.dock = { config, pkgs, ... }: {
    # content from current modules/darwin/dock.nix
    # replace hostConfig.* with config.meta.*
  };
}
```

**HM-only feature** (e.g., git.nix):
```nix
{ ... }:
{
  flake.modules.homeManager.git = { pkgs, ... }: {
    # content from current modules/shared/programs/git/default.nix
  };
}
```

**Cross-cutting feature** (e.g., vscode):
```nix
{ ... }:
{
  flake.modules.darwin.vscode = {
    homebrew.casks = [{ name = "visual-studio-code"; }];
  };
  flake.modules.homeManager.vscode = { pkgs, ... }: {
    programs.vscode = {
      enable = true;
      userSettings = import ./_config/user.nix;
      # ...
    };
  };
}
```

### Features to migrate (with source -> destination):

| Current file | New file | Type |
|---|---|---|
| modules/darwin/dock.nix | modules/features/dock.nix | darwin |
| modules/darwin/finder.nix | modules/features/finder.nix | darwin |
| modules/darwin/fonts.nix | modules/features/fonts.nix | darwin |
| modules/darwin/homebrew.nix | modules/features/homebrew.nix | darwin |
| modules/darwin/launchAgents.nix | modules/features/launch-agents.nix | darwin |
| modules/darwin/preferences.nix | modules/features/preferences.nix | darwin |
| modules/darwin/security.nix | modules/features/security.nix | darwin |
| modules/darwin/services.nix | modules/features/services.nix | darwin |
| modules/darwin/system.nix + documentation.nix | modules/features/system.nix | darwin |
| modules/darwin/programs/1password-agent/ | modules/features/1password.nix | cross |
| modules/darwin/programs/brave/ | modules/features/brave.nix | darwin |
| modules/darwin/programs/ghostty/ | modules/features/ghostty.nix | cross |
| modules/darwin/programs/hammerspoon/ | modules/features/hammerspoon/ | cross |
| modules/darwin/programs/vscode/ | modules/features/vscode/ | cross |
| modules/shared/packages.nix + darwin/packages.nix | modules/features/packages.nix | HM |
| modules/shared/programs/claude-code.nix | modules/features/claude-code.nix | HM |
| modules/shared/programs/direnv.nix | modules/features/direnv.nix | HM |
| modules/shared/programs/doggo.nix | modules/features/doggo.nix | HM |
| modules/shared/programs/fd.nix | modules/features/fd.nix | HM |
| modules/shared/programs/gh.nix | modules/features/gh.nix | HM |
| modules/shared/programs/k9s.nix | modules/features/k9s.nix | HM |
| modules/shared/programs/ssh.nix | modules/features/ssh.nix | HM |
| modules/shared/programs/zoxide.nix | modules/features/zoxide.nix | HM |
| modules/shared/programs/git/ | modules/features/git.nix | HM |
| modules/shared/programs/neovim/ | modules/features/neovim/ | HM |
| modules/shared/programs/zsh/ | modules/features/zsh/ | HM |
| (new) | modules/features/mailerlite.nix | cross |

### Key migration notes per feature:

- **dock.nix**: Replace `hostConfig.dockPathOverrides` with `config.meta.dockPathOverrides`
- **packages.nix**: Merge darwin/packages.nix + shared/packages.nix. Replace `hostConfig.extraHomeManagerPackages` with `config.meta.extraHomeManagerPackages`. Remove `with pkgs;` anti-pattern
- **ssh.nix**: Replace `hostConfig` references with `config.meta.*`
- **neovim/**: Move `nvim/` to `_nvim/` (underscore prefix hides from import-tree)
- **zsh/**: Move `config/` to `_config/`
- **hammerspoon/**: Move `config/` to `_config/`
- **vscode/**: Move `config/` to `_config/`
- **mailerlite.nix**: New file wrapping `inputs.mailerlite.modules.darwin.defaults` and `.home-manager.defaults`

## Phase 4: Composition Modules

### 4a. `modules/base.nix`
```nix
{ config, ... }:
let
  inherit (config.flake.modules) darwin homeManager generic;
in
{
  flake.modules.darwin.base = {
    imports = [
      generic.meta
      darwin.overlays
      darwin.system
      darwin.dock
      darwin.finder
      darwin.fonts
      darwin.homebrew
      darwin.preferences
      darwin.security
      darwin.services
      darwin.launchAgents
      darwin.homeManager
      darwin.nixHomebrew
      darwin.vscode
      darwin.ghostty
      darwin.1password
      darwin.brave
      darwin.hammerspoon
    ];
  };

  flake.modules.homeManager.base = {
    imports = [
      generic.meta
      homeManager.packages
      homeManager.git
      homeManager.zsh
      homeManager.neovim
      homeManager.claudeCode
      homeManager.direnv
      homeManager.doggo
      homeManager.fd
      homeManager.gh
      homeManager.k9s
      homeManager.ssh
      homeManager.zoxide
      homeManager.vscode
      homeManager.ghostty
      homeManager.1password
      homeManager.hammerspoon
    ];
  };
}
```

### 4b. `modules/hosts/titan.nix`

Note: mailerlite module also needs host-specific config (team=sre, direnv disabled, ssh username).
The feature wraps the module import; the host sets the config values.

```nix
{ config, inputs, ... }:
let
  inherit (config.flake.modules) darwin homeManager;
in
{
  configurations.darwin.titan.module = {
    imports = [
      darwin.base
      darwin.mailerlite
    ];

    meta.dockPathOverrides = {
      "/Applications/Beeper Desktop.app/" = "/Applications/Slack.app/";
    };
    meta.extraHomeManagerPackages = inputs.mailerlite.pkgs.aarch64-darwin.sre;
    mailerlite.team = "sre";

    home-manager.sharedModules = [
      homeManager.base
      homeManager.mailerlite
      {
        mailerlite = {
          team = "sre";
          direnv.enable = false;
          ssh.username = "robert";
        };
      }
    ];
  };
}
```

### 4c. `modules/hosts/thebe.nix`
```nix
{ config, ... }:
let
  inherit (config.flake.modules) darwin homeManager;
in
{
  configurations.darwin.thebe.module = {
    imports = [ darwin.base ];
    home-manager.sharedModules = [ homeManager.base ];
  };
}
```

## Phase 5: Rewrite flake.nix

```nix
{
  description = "Nix configuration for titan and thebe";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
    nix-darwin = { url = "github:LnL7/nix-darwin/master"; inputs.nixpkgs.follows = "nixpkgs"; };
    home-manager = { url = "github:nix-community/home-manager"; inputs.nixpkgs.follows = "nixpkgs"; };
    flake-parts = { url = "github:hercules-ci/flake-parts"; };
    import-tree = { url = "github:vic/import-tree"; };
    nix4vscode = { url = "github:nix-community/nix4vscode"; inputs.nixpkgs.follows = "nixpkgs"; };
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    homebrew-core = { url = "github:homebrew/homebrew-core"; flake = false; };
    homebrew-cask = { url = "github:homebrew/homebrew-cask"; flake = false; };
    lefthook = { url = "github:sudosubin/lefthook.nix"; inputs.nixpkgs.follows = "nixpkgs"; };
    claude-code-overlay = { url = "github:nklmilojevic/claude-code-overlay"; };
    mailerlite = {
      url = "path:/Users/robert/dev/mailerlite/mailerlite-nix-config";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs-stable";
      inputs.claude-code-overlay.follows = "claude-code-overlay";
    };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; }
      (inputs.import-tree ./modules);
}
```

## Phase 6: Delete Old Files

Remove all files that have been migrated:
- `hosts.nix`
- `lib/` (entire directory)
- `hosts/` (entire directory -- hosts/darwin/default.nix)
- `modules/darwin/` (entire directory)
- `modules/shared/` (entire directory)

## Phase 7: Verify

1. `git add -A` (stage everything so nix can see new files)
2. `nix flake check` -- must pass
3. `task build` -- must successfully switch
4. Verify applications work (dock, VS Code settings, etc.)

## Execution Note

This migration is **atomic** -- the flake either uses the old pattern or the new one. It cannot be split into independent PRs/worktrees that merge separately. The implementation should be done sequentially on a single branch, with one final commit containing all changes. Individual phases can be verified mentally but only the complete changeset will pass `nix flake check`.
