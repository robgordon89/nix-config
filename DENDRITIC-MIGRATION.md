# Dendritic Migration Plan

## Context

Migrate nix-config from the traditional flake pattern (manual imports, `specialArgs`/`hostConfig`, `mkHost` builder) to the Dendritic pattern (flake-parts + import-tree, feature-based modules, `meta` options). This prepares the config for future Linux HM hosts and potential NixOS.

**Current hosts (unchanged):**
- **titan** — work machine, MailerLite SRE team, overrides Beeper→Slack in dock
- **thebe** — personal machine, uses defaults

## Decisions Summary

Locked during spec interview. Anything not listed here is implementation detail left to the executor's judgement, but must preserve current behavior.

| Decision | Value |
|---|---|
| Categorization shape | Directories only under `modules/features/{system,developer,desktop,work}/`. `base.nix` still imports each feature file individually. No per-category base modules, no tiers, no class tags. |
| Category mapping | See [Target Structure](#target-structure) |
| `meta.work.*` abstraction | `meta.work.enable` + `meta.work.team`. The mailerlite feature derives ssh username, extra packages, and direnv disable from these. |
| Work feature placement | `features/work/mailerlite.nix` is **NOT in `base.nix`**. Host files that want work config import it explicitly. |
| SSH feature | Lives in `features/developer/ssh.nix`, opt-in via `meta.ssh.enable` (default `false`). Mailerlite feature flips it on via `lib.mkDefault true`. |
| Package splitting | 3 files: `features/developer/packages/{core,languages,ops}.nix` |
| Package opt-out | Host sets `meta.packages.groups` (opt-in list) and `meta.packages.exclude` (attrname list). Each group file exports an attrset filtered via `lib.removeAttrs`. |
| `claudeCode.useVertex` | **Dropped.** User no longer uses Vertex. Remove the conditional `claudeCode.disableLoginPrompt` line from vscode user settings. |
| HM workarounds | New file `features/system/hm-workarounds.nix` preserves all current workaround flags verbatim. |
| Feature composition | A feature is a **bundle** that can declare any combination of: a darwin module (including `homebrew.casks`), a homeManager module, and `nixpkgs` config. A single feature file owns all three parts for one logical unit (e.g. `vscode.nix` bundles the darwin cask + HM `programs.vscode` + any extensions config). `features/system/homebrew.nix` holds only the base homebrew config (enable/cleanup/upgrade/taps) — zero casks. Each of the 14 current casks is owned by a feature in the appropriate category. |
| Per-host feature selection | **No opt-out mechanism.** Features shared by all hosts live in `base.nix`. Host-specific features are imported explicitly by the hosts that want them — hosts that don't want them simply omit them from their imports list. Titan-only features: `slack`, `zoom`, `mailerlite`. Thebe-only features: `beeper` (new cask). All other features (including their casks + any future HM config) live in `base.nix`. |
| `nix-homebrew` | `mutableTaps = false`, `autoMigrate = true` |
| `home.stateVersion` | `"25.05"` (current value; spec draft incorrectly said `"24.05"`) |
| Execution | Single atomic commit on branch `dendritic-migration`. |
| Host → meta wiring | Meta defined as a `let` binding in the host file, inherited into both the darwin tree and into a `{ inherit meta; }` module inside `home-manager.sharedModules`. |

## Target Structure

```
flake.nix                                    # inputs + mkFlake + import-tree ./modules

modules/
  flake-parts.nix                            # enables flake.modules, sets systems
  darwin-configurations.nix                  # configurations.darwin -> flake.darwinConfigurations
  meta.nix                                   # generic module: all meta.* options
  overlays.nix                               # nixpkgs.overlays via darwin.overlays
  home-manager.nix                           # HM darwinModule wiring + user setup
  nix-homebrew.nix                           # nix-homebrew darwinModule wiring
  per-system.nix                             # formatter, devShells, checks
  base.nix                                   # composes all non-work features

  features/
    system/
      dock.nix                               # darwin.dock
      finder.nix                             # darwin.finder
      fonts.nix                              # darwin.fonts
      homebrew.nix                           # darwin.homebrew (base config only — NO casks)
      launch-agents.nix                      # darwin.launchAgents
      preferences.nix                        # darwin.preferences
      security.nix                           # darwin.security
      services.nix                           # darwin.services
      system.nix                             # darwin.system (merges old system.nix + documentation.nix)
      hm-workarounds.nix                     # homeManager.hmWorkarounds
      logi-options.nix                       # darwin.logiOptions (cask: logi-options+)
      cloudflare-warp.nix                    # darwin.cloudflareWarp (cask: cloudflare-warp)

    developer/
      1password.nix                          # darwin.onePassword (cask: 1password) + homeManager.onePassword
      ghostty.nix                            # darwin.ghostty (cask: ghostty) + homeManager.ghostty
      vscode/
        vscode.nix                           # darwin.vscode (cask: visual-studio-code) + homeManager.vscode
        _config/
          user.nix
          keybindings.nix
          mcp.nix
      neovim/
        neovim.nix                           # homeManager.neovim
        _nvim/                               # existing nvim/ dir moved here (underscore hides from import-tree)
      zsh/
        zsh.nix                              # homeManager.zsh
        _config/                             # existing zsh/config/ moved here
      git.nix                                # homeManager.git
      gh.nix                                 # homeManager.gh
      direnv.nix                             # homeManager.direnv
      claude-code.nix                        # homeManager.claudeCode
      zoxide.nix                             # homeManager.zoxide
      fd.nix                                 # homeManager.fd
      doggo.nix                              # homeManager.doggo
      k9s.nix                                # homeManager.k9s
      ssh.nix                                # homeManager.ssh
      tableplus.nix                          # darwin.tableplus (cask: tableplus)
      medis.nix                              # darwin.medis (cask: medis)
      syntax-highlight.nix                   # darwin.syntaxHighlight (cask: syntax-highlight)
      packages/
        core.nix                             # homeManager.packagesCore
        languages.nix                        # homeManager.packagesLanguages
        ops.nix                              # homeManager.packagesOps

    desktop/
      brave.nix                              # darwin.brave (cask: brave-browser)
      hammerspoon/
        hammerspoon.nix                      # darwin.hammerspoon (cask: hammerspoon) + homeManager.hammerspoon
        _config/                             # existing hammerspoon/config/ moved here
      cleanshot.nix                          # darwin.cleanshot (cask: cleanshot)
      swiftbar.nix                           # darwin.swiftbar (cask: swiftbar)
      slack.nix                              # darwin.slack (cask: slack)    -- NOT in base, titan-only
      zoom.nix                               # darwin.zoom (cask: zoom)      -- NOT in base, titan-only
      beeper.nix                             # darwin.beeper (cask: beeper)  -- NOT in base, thebe-only (NEW)

    work/
      mailerlite.nix                         # darwin.mailerlite + homeManager.mailerlite (NOT in base)

  hosts/
    titan.nix                                # imports darwin.base + darwin.{slack,zoom,mailerlite}, sets meta
    thebe.nix                                # imports darwin.base only, no meta overrides

overlays/                                    # kept as-is, referenced by overlays.nix
pkgs/                                        # kept as-is
```

**import-tree convention**: directories and files prefixed with `_` are ignored by import-tree. This is used for config data files (e.g., `_config/user.nix`, `_nvim/`) that should be imported explicitly, not auto-loaded as flake-parts modules.

**Module attribute naming**: flake-parts option names (e.g., `flake.modules.darwin.launchAgents`) use **camelCase** because they are nix attribute names. Feature filenames use **kebab-case** because they are filenames. So `features/system/launch-agents.nix` sets `flake.modules.darwin.launchAgents`.

## Phase 0: Commit Cleanup

Commit any existing uncommitted changes as a separate commit on `main` **before** starting the migration branch.

## Phase 1: Create Branch + Add Inputs

**Branch**: `dendritic-migration`

Edit `flake.nix` to add two new inputs:

```nix
flake-parts.url = "github:hercules-ci/flake-parts";
import-tree.url = "github:vic/import-tree";
```

Run `nix flake update flake-parts import-tree` to lock them. (Full flake.nix rewrite happens in Phase 5; this phase just adds inputs so the rewrite compiles.)

## Phase 2: Infrastructure Modules

Create all infrastructure modules before touching feature code.

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

Wires `configurations.darwin` → `flake.darwinConfigurations` output.

```nix
{ lib, flake-parts-lib, config, inputs, ... }:
{
  options = {
    configurations.darwin = lib.mkOption {
      type = lib.types.lazyAttrsOf (lib.types.submodule {
        options = {
          system = lib.mkOption {
            type = lib.types.str;
            default = "aarch64-darwin";
          };
          module = lib.mkOption {
            type = lib.types.deferredModule;
            default = { };
          };
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

Generic module defining the `meta` options. Imported into both darwin and homeManager base modules.

```nix
{ ... }:
{
  flake.modules.generic.meta = { lib, config, ... }: {
    options.meta = {
      username = lib.mkOption {
        type = lib.types.str;
        default = "robert";
        description = "Unix username. Used for home dir, dock, ssh, etc.";
      };
      firstName = lib.mkOption {
        type = lib.types.str;
        default = "Robert";
      };
      lastName = lib.mkOption {
        type = lib.types.str;
        default = "Gordon";
      };
      fullName = lib.mkOption {
        type = lib.types.str;
        default = "${config.meta.firstName} ${config.meta.lastName}";
        defaultText = lib.literalExpression ''"''${config.meta.firstName} ''${config.meta.lastName}"'';
      };
      email = lib.mkOption {
        type = lib.types.str;
        default = "rob@ruled.io";
      };
      sshPublicKey = lib.mkOption {
        type = lib.types.str;
        default = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEJOD+xGS8a9Q2Dyyah+jH6caM2n4XaJNKRvmbo7NqaY";
        description = "Public key used for git commit signing.";
      };

      dockPathOverrides = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = { };
        description = ''
          Map of app path substitutions for the dock, e.g.
          { "/Applications/Beeper Desktop.app/" = "/Applications/Slack.app/"; }
        '';
      };
      dock = lib.mkOption {
        type = lib.types.attrs;
        default = { };
        description = "Host-specific raw overrides for system.defaults.dock (priority 80).";
      };

      ssh = {
        enable = lib.mkEnableOption "managed ~/.ssh/config generation";
        username = lib.mkOption {
          type = lib.types.str;
          default = config.meta.username;
          defaultText = lib.literalExpression "config.meta.username";
        };
        includeOrbstack = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
        use1PasswordAgent = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
        extraConfig = lib.mkOption {
          type = lib.types.lines;
          default = "";
        };
      };

      work = {
        enable = lib.mkEnableOption "work (mailerlite) configuration";
        team = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "Mailerlite team identifier (e.g., \"sre\"). Required when work.enable = true.";
        };
      };

      packages = {
        groups = lib.mkOption {
          type = lib.types.listOf (lib.types.enum [ "core" "languages" "ops" ]);
          default = [ "core" "languages" "ops" ];
          description = "Package groups to include on this host.";
        };
        exclude = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = ''
            Nix attribute names to exclude from any package group's set.
            Names must match the attribute key used inside the group file's
            package attrset (not the derivation pname).
          '';
        };
      };
    };
  };
}
```

**Note**: `platform` is handled by `configurations.darwin.<host>.system`. `claudeCode.useVertex` is intentionally dropped.

### 2d. `modules/overlays.nix`

```nix
{ inputs, ... }:
{
  flake.modules.darwin.overlays = {
    nixpkgs.overlays = builtins.attrValues (import ../overlays { inherit inputs; });
    nixpkgs.config.allowUnfree = true;
  };
}
```

Keeps the existing `overlays/` directory and its current auto-discovery. The `import ../overlays` call is unchanged; we just apply the result via `nixpkgs.overlays` instead of constructing `pkgs` manually.

### 2e. `modules/home-manager.nix`

Wires the home-manager darwinModule and sets up the user.

```nix
{ inputs, ... }:
{
  flake.modules.darwin.homeManager = { config, pkgs, ... }: {
    imports = [ inputs.home-manager.darwinModules.home-manager ];

    users.users.${config.meta.username} = {
      home = "/Users/${config.meta.username}";
      shell = pkgs.zsh;
    };

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "backup";
    };

    home-manager.users.${config.meta.username} = {
      programs.home-manager.enable = true;
      home.stateVersion = "25.05";
      home.enableNixpkgsReleaseCheck = false;
    };
  };
}
```

**Note**: This wiring module depends on `meta.username`. Hosts must import `generic.meta` into both their darwin module list and their HM sharedModules (handled by `base.nix`).

### 2f. `modules/nix-homebrew.nix`

```nix
{ inputs, ... }:
{
  flake.modules.darwin.nixHomebrew = { config, ... }: {
    imports = [ inputs.nix-homebrew.darwinModules.nix-homebrew ];
    nix-homebrew = {
      enable = true;
      user = config.meta.username;
      autoMigrate = true;
      mutableTaps = false;
      taps = {
        "homebrew/homebrew-core" = inputs.homebrew-core;
        "homebrew/homebrew-cask" = inputs.homebrew-cask;
      };
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
      inherit (inputs.lefthook.lib.${system}.run {
        src = inputs.self;
        config.pre-commit.commands.nixfmt = {
          run = "${pkgs.lib.getExe pkgs.nixfmt} {staged_files}";
          glob = "*.nix";
        };
      }) shellHook;
      nativeBuildInputs = builtins.attrValues {
        inherit (pkgs) nixpkgs-fmt nil go-task nixfmt;
      };
    };

    checks.lefthook-check = inputs.lefthook.lib.${system}.run {
      src = inputs.self;
      config.pre-commit.commands.nixfmt = {
        run = "${pkgs.lib.getExe pkgs.nixfmt} {staged_files}";
        glob = "*.nix";
      };
    };
  };
}
```

Matches current `flake.nix` devShell/checks behavior.

## Phase 3: Feature Modules

For each feature below, the pattern is:

```nix
# features/<category>/<name>.nix
{ ... }:
{
  flake.modules.<class>.<camelName> = { config, lib, pkgs, ... }: {
    # content ported verbatim from current module
    # replace hostConfig.X with config.meta.X
  };
}
```

Cross-cutting features set **both** `flake.modules.darwin.X` and `flake.modules.homeManager.X` inside the same file.

### Migration Table

| Current source | New destination | Class(es) |
|---|---|---|
| `modules/darwin/dock.nix` | `features/system/dock.nix` | darwin |
| `modules/darwin/finder.nix` | `features/system/finder.nix` | darwin |
| `modules/darwin/fonts.nix` | `features/system/fonts.nix` | darwin |
| `modules/darwin/homebrew.nix` (base only, no casks) | `features/system/homebrew.nix` | darwin |
| `modules/darwin/launchAgents.nix` | `features/system/launch-agents.nix` | darwin |
| `modules/darwin/preferences.nix` | `features/system/preferences.nix` | darwin |
| `modules/darwin/security.nix` | `features/system/security.nix` | darwin |
| `modules/darwin/services.nix` | `features/system/services.nix` | darwin |
| `modules/darwin/system.nix` + `documentation.nix` | `features/system/system.nix` (merged) | darwin |
| (new) | `features/system/hm-workarounds.nix` | homeManager |
| cask `logi-options+` from `homebrew.nix` | `features/system/logi-options.nix` (new) | darwin |
| cask `cloudflare-warp` from `homebrew.nix` | `features/system/cloudflare-warp.nix` (new) | darwin |
| `modules/darwin/programs/1password-agent/` + cask `1password` | `features/developer/1password.nix` | darwin + homeManager |
| `modules/darwin/programs/ghostty/` + cask `ghostty` | `features/developer/ghostty.nix` | darwin + homeManager |
| `modules/darwin/programs/vscode/` + cask `visual-studio-code` | `features/developer/vscode/` | darwin + homeManager |
| `modules/shared/programs/git/` | `features/developer/git.nix` | homeManager |
| `modules/shared/programs/gh.nix` | `features/developer/gh.nix` | homeManager |
| `modules/shared/programs/direnv.nix` | `features/developer/direnv.nix` | homeManager |
| `modules/shared/programs/claude-code.nix` | `features/developer/claude-code.nix` | homeManager |
| `modules/shared/programs/zsh/` | `features/developer/zsh/` | homeManager |
| `modules/shared/programs/neovim/` | `features/developer/neovim/` | homeManager |
| `modules/shared/programs/zoxide.nix` | `features/developer/zoxide.nix` | homeManager |
| `modules/shared/programs/fd.nix` | `features/developer/fd.nix` | homeManager |
| `modules/shared/programs/doggo.nix` | `features/developer/doggo.nix` | homeManager |
| `modules/shared/programs/k9s.nix` | `features/developer/k9s.nix` | homeManager |
| `modules/shared/programs/ssh.nix` | `features/developer/ssh.nix` | homeManager |
| cask `tableplus` from `homebrew.nix` | `features/developer/tableplus.nix` (new) | darwin |
| cask `medis` from `homebrew.nix` | `features/developer/medis.nix` (new) | darwin |
| cask `syntax-highlight` from `homebrew.nix` | `features/developer/syntax-highlight.nix` (new) | darwin |
| `modules/darwin/packages.nix` + `modules/shared/packages.nix` | `features/developer/packages/{core,languages,ops}.nix` | homeManager |
| `modules/darwin/programs/brave/` + cask `brave-browser` | `features/desktop/brave.nix` | darwin |
| `modules/darwin/programs/hammerspoon/` + cask `hammerspoon` | `features/desktop/hammerspoon/` | darwin + homeManager |
| cask `slack` from `homebrew.nix` | `features/desktop/slack.nix` (new) | darwin |
| cask `zoom` from `homebrew.nix` | `features/desktop/zoom.nix` (new) | darwin |
| (new cask `beeper`) | `features/desktop/beeper.nix` (new) | darwin |
| cask `cleanshot` from `homebrew.nix` | `features/desktop/cleanshot.nix` (new) | darwin |
| cask `swiftbar` from `homebrew.nix` | `features/desktop/swiftbar.nix` (new) | darwin |
| (new) | `features/work/mailerlite.nix` | darwin + homeManager |

Files **not** migrated: `modules/darwin/programs/wezterm/` — leave behind (it's already unused; delete in Phase 6 with the rest of `modules/darwin/`).

### Per-feature Migration Notes

Unless otherwise noted, each feature ports its current content verbatim, only replacing `hostConfig.*` references with `config.meta.*`.

#### `features/system/system.nix` (merged)

Merges content from `modules/darwin/system.nix` and `modules/darwin/documentation.nix` into one darwin module. No logic change — just concatenation inside a single `flake.modules.darwin.system = { ... }` block.

#### `features/system/homebrew.nix` (base only — no casks)

After migration this module holds only the base homebrew configuration. **Zero `casks` entries.** Each cask moves to its own feature file (see "Feature composition pattern" below).

```nix
{ ... }:
{
  flake.modules.darwin.homebrew = { config, ... }: {
    homebrew = {
      enable = true;
      onActivation.cleanup = "uninstall";
      onActivation.upgrade = true;
      global.autoUpdate = true;
      taps = builtins.attrNames config.nix-homebrew.taps;
    };
  };
}
```

**Behavior preservation note**: `onActivation.cleanup = "uninstall"` means any cask not declared by an imported feature gets uninstalled. That's the point of this refactor — casks are explicitly owned by features. Before merging, confirm all 14 current casks are still declared *somewhere* in `modules/features/**/*.nix`. (`beeper` is a 15th cask added by this migration; see "Intentional Behavior Changes".)

### Feature composition pattern

A **feature** is a bundle for one logical unit. A single feature file can declare any combination of three parts:

1. A **darwin module** (`flake.modules.darwin.<name>`) — system-level config, including `homebrew.casks` for a brew cask.
2. A **homeManager module** (`flake.modules.homeManager.<name>`) — user-level config (dotfiles, `programs.*`).
3. **nixpkgs config** — overlays, allowed unfree lists, etc.

Features are "bundles" rather than casks-only or HM-only units. Each of the 14 current casks (and the new `beeper` cask) is owned by exactly one feature in the appropriate category. That feature may today contain only the cask, but its file is where all future darwin + HM config for that app will live.

**Shape A — Multi-part feature** (vscode, ghostty, 1password, brave, hammerspoon). Bundles darwin + HM sides under one name.

```nix
# features/developer/ghostty.nix
{ ... }:
{
  flake.modules.darwin.ghostty = {
    homebrew.casks = [ { name = "ghostty"; greedy = true; } ];
  };

  flake.modules.homeManager.ghostty = { pkgs, ... }: {
    # programs.ghostty config ported from current module
  };
}
```

**Shape B — Cask-only feature** (swiftbar, tableplus, medis, etc.). The file contains only the darwin cask declaration today. Future nix config for the same app (e.g. swiftbar plugins, tableplus settings) is added to this same file.

```nix
# features/desktop/swiftbar.nix
{ ... }:
{
  flake.modules.darwin.swiftbar = {
    homebrew.casks = [ { name = "swiftbar"; greedy = true; } ];
  };

  # Future: flake.modules.homeManager.swiftbar for plugin dir, etc.
}
```

**Feature file rules:**
1. Every `homebrew.casks` entry **must** carry `greedy = true;` — current `modules/darwin/homebrew.nix` wraps all 14 casks in `mkGreedy`, and this behavior must survive the migration. The new `beeper` feature must also carry `greedy = true;`.
2. The flake module attribute name uses camelCase even when the cask/app name has dashes or special chars (e.g. `darwin.cloudflareWarp` for the `cloudflare-warp` cask; `darwin.logiOptions` for `logi-options+`).
3. File names are kebab-case, minus special characters (`logi-options.nix` for `logi-options+`).
4. Cross-cutting features use the **same name** for their darwin and homeManager modules. Example: `flake.modules.darwin.ghostty` and `flake.modules.homeManager.ghostty` are both parts of the single `ghostty` feature.
5. A feature is "on" a host when that host (directly or via `base.nix`) imports **all** of its module parts. Host files add both `darwin.<name>` and `homeManager.<name>` when a cross-cutting feature is opt-in per host.
6. Whatever is in `base.nix` gets installed on every host. Anything omitted from `base.nix` is opted into by hosts that want it. Homebrew's `onActivation.cleanup = "uninstall"` means an unimported feature's cask will be removed on the next switch.

**All casks owned by features (14 existing + 1 new):**

| Cask | Feature file | Darwin attr | In base.nix? |
|---|---|---|---|
| `1password` | `features/developer/1password.nix` | `darwin.onePassword` | yes |
| `ghostty` | `features/developer/ghostty.nix` | `darwin.ghostty` | yes |
| `visual-studio-code` | `features/developer/vscode/vscode.nix` | `darwin.vscode` | yes |
| `tableplus` | `features/developer/tableplus.nix` | `darwin.tableplus` | yes |
| `medis` | `features/developer/medis.nix` | `darwin.medis` | yes |
| `syntax-highlight` | `features/developer/syntax-highlight.nix` | `darwin.syntaxHighlight` | yes |
| `brave-browser` | `features/desktop/brave.nix` | `darwin.brave` | yes |
| `hammerspoon` | `features/desktop/hammerspoon/hammerspoon.nix` | `darwin.hammerspoon` | yes |
| `cleanshot` | `features/desktop/cleanshot.nix` | `darwin.cleanshot` | yes |
| `swiftbar` | `features/desktop/swiftbar.nix` | `darwin.swiftbar` | yes |
| `logi-options+` | `features/system/logi-options.nix` | `darwin.logiOptions` | yes |
| `cloudflare-warp` | `features/system/cloudflare-warp.nix` | `darwin.cloudflareWarp` | yes |
| `slack` | `features/desktop/slack.nix` | `darwin.slack` | **no** — titan only |
| `zoom` | `features/desktop/zoom.nix` | `darwin.zoom` | **no** — titan only |
| `beeper` *(new)* | `features/desktop/beeper.nix` | `darwin.beeper` | **no** — thebe only |

#### `features/system/hm-workarounds.nix` (new)

Captures all HM workarounds currently in `modules/darwin/home-manager.nix`. Applied via `home-manager.sharedModules` in `base.nix`.

```nix
{ ... }:
{
  flake.modules.homeManager.hmWorkarounds = { ... }: {
    # Workaround: home-manager passes string instead of list to pathsToLink
    # https://github.com/nix-community/home-manager/issues/8163
    targets.darwin.linkApps.enable = false;
    home.file."Library/Fonts/.home-manager-fonts-version".enable = false;

    # Workaround: marked broken Oct 2022, revisit periodically
    # https://github.com/nix-community/home-manager/issues/3344
    manual.manpages.enable = false;

    # Skip manpage cache generation to speed up builds
    programs.man.generateCaches = false;
  };
}
```

`backupFileExtension`, `home.stateVersion`, and `home.enableNixpkgsReleaseCheck` live in `modules/home-manager.nix` (2e) because they are HM infrastructure, not bug workarounds.

#### `features/system/dock.nix`

Ports `modules/darwin/dock.nix`. Replace:
- `hostConfig.dockPathOverrides` → `config.meta.dockPathOverrides`
- `hostConfig.username` → `config.meta.username`
- `hostConfig.dock` → `config.meta.dock`

Full function signature becomes `{ config, lib, pkgs, ... }:`.

#### `features/developer/ssh.nix`

Ports `modules/shared/programs/ssh.nix` with meta-based gating:

```nix
{ ... }:
{
  flake.modules.homeManager.ssh = { config, lib, ... }:
  let
    cfg = config.meta.ssh;
  in
  lib.mkIf cfg.enable {
    home.file.".ssh/config".text = ''
      # Basic SSH Configuration
      # Generated by nix-config - DO NOT EDIT MANUALLY

      ${lib.optionalString cfg.includeOrbstack ''
        Include ~/.orbstack/ssh/config
      ''}

      Host *
        AddKeysToAgent yes
        User ${cfg.username}
        UseKeychain yes
        ${lib.optionalString cfg.use1PasswordAgent ''
          IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
        ''}

      ${cfg.extraConfig}
    '';

    home.activation.ensureSshDirectory = lib.hm.dag.entryBefore [ "writeBoundary" ] ''
      $DRY_RUN_CMD mkdir -p $VERBOSE_ARG ~/.ssh
      $DRY_RUN_CMD chmod 700 $VERBOSE_ARG ~/.ssh
    '';
  };
}
```

`meta.ssh.enable` defaults to `false`. Only the mailerlite feature flips it on (see `features/work/mailerlite.nix` below). Thebe gets no ssh config — identical to current behavior.

#### `features/developer/git.nix`

Ports `modules/shared/programs/git/`. Replace:
- `hostConfig.fullName` → `config.meta.fullName`
- `hostConfig.email` → `config.meta.email`
- `hostConfig.sshPublicKey` → `config.meta.sshPublicKey`

#### `features/developer/claude-code.nix`

Ports `modules/shared/programs/claude-code.nix` verbatim. No `hostConfig` references to replace.

#### `features/developer/vscode/vscode.nix`

Ports `modules/darwin/programs/vscode/default.nix`. Follows "Shape A" of the feature composition pattern (darwin side owns the `visual-studio-code` cask, HM side configures VS Code).

One additional change beyond the path updates: **drop Vertex code.** In `features/developer/vscode/_config/user.nix`, remove the entire `// lib.optionalAttrs useVertex { "claudeCode.disableLoginPrompt" = true; }` suffix. Also delete the `claudeCodeCfg` and `useVertex` let bindings. The function signature becomes `{ lib, ... }:` (no `hostConfig`).

`_config/user.nix`, `_config/keybindings.nix`, `_config/mcp.nix` are the existing files relocated under the `_config/` prefix so import-tree ignores them.

#### `features/developer/neovim/` and `features/developer/zsh/`

Rename the existing `nvim/` and `config/` subdirectories to `_nvim/` and `_config/` respectively. Update the `import` / `readFile` paths inside `neovim.nix` / `zsh.nix` accordingly.

#### `features/desktop/hammerspoon/` and `features/developer/vscode/`

Same pattern — rename `config/` to `_config/` and update import paths.

#### `features/developer/packages/core.nix`

Combines:
- Tools, Security, Linters, SaaS, AI, Containers, Shell tools sections from current `modules/shared/packages.nix`
- Darwin-specific additions (`tart`, `packer`) from current `modules/darwin/packages.nix`

**Note**: The user chose to merge "core" and "shell" into a single `core.nix`. The SaaS section stays in `core.nix` because the interviewer's cloud/ops split was collapsed to 3 files.

```nix
{ ... }:
{
  flake.modules.homeManager.packagesCore = { config, lib, pkgs, ... }:
    lib.mkIf (lib.elem "core" config.meta.packages.groups) {
      home.packages =
        let
          all = {
            # Tools
            inherit (pkgs)
              curl wget openssl jq fzf git sops age mtr netcat socat nmap
              restic statix ansible-lint nixpkgs-fmt poetry hugo flyctl
              minio-client go-task chart-testing cmctl swaks ncdu gdu
              graphviz uv parallel doctl ngrok todo-txt-cli wireguard-tools
              tart packer
              ;
            yq-go = pkgs.lib.hiPrio pkgs.yq-go;
            ffmpeg-full = pkgs.ffmpeg-full;
            octodns = pkgs.octodns.withProviders (_: [ pkgs.octodns.providers.cloudflare ]);

            # Security
            inherit (pkgs) gnupg yubikey-manager pinentry_mac;

            # Linters
            inherit (pkgs) golangci-lint;

            # AI tools
            inherit (pkgs) claude-code cursor-cli codex gemini-cli;

            # SaaS / cloud
            _1password-cli = pkgs._1password-cli;
            inherit (pkgs) opentofu spacectl awscli2;
            google-cloud-sdk = pkgs.google-cloud-sdk.withExtraComponents [
              pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin
            ];

            # Shell tools
            inherit (pkgs) eza bat procs pre-commit nix-your-shell kcl lefthook slides;
          };
        in
        lib.attrValues (lib.removeAttrs all config.meta.packages.exclude);
    };
}
```

The `all` attrset key **is** the exclusion name. `meta.packages.exclude = [ "awscli2" ]` would drop `awscli2` from `core`. Use attrset keys that differ from `pkgs.` accessors when you need to (e.g., `yq-go`, `octodns`, `google-cloud-sdk`).

#### `features/developer/packages/languages.nix`

```nix
{ ... }:
{
  flake.modules.homeManager.packagesLanguages = { config, lib, pkgs, ... }:
    lib.mkIf (lib.elem "languages" config.meta.packages.groups) {
      home.packages =
        let
          all = {
            python = pkgs.python313.buildEnv.override {
              extraLibs = with pkgs.python313.pkgs; [
                pyyaml ruff ansible-core git-filter-repo llm llm-ollama llm-cmd
              ];
            };
            inherit (pkgs) typescript yarn bun cue go php83 deployer cargo;
            composer = pkgs.lib.hiPrio pkgs.php83Packages.composer;
            php-cs-fixer = pkgs.php83Packages.php-cs-fixer;
          };
        in
        lib.attrValues (lib.removeAttrs all config.meta.packages.exclude);
    };
}
```

**Caveat**: `modules/shared/packages.nix` lines 95-96 are:
```nix
(pkgs.lib.hiPrio php83Packages.composer)
php83Packages.php-cs-fixer
```
Both must be preserved. Two distinct attrset keys (`composer` and `php-cs-fixer`) achieve this, with `hiPrio` on composer to match current priority.

#### `features/developer/packages/ops.nix`

```nix
{ ... }:
{
  flake.modules.homeManager.packagesOps = { config, lib, pkgs, ... }:
    lib.mkIf (lib.elem "ops" config.meta.packages.groups) {
      home.packages =
        let
          all = {
            inherit (pkgs)
              kubectl-df-pv kubectx fluxcd kubeconform kubernetes-helm
              skaffold caddy kubebuilder tailscale cilium-cli
              ;
            orbstack = pkgs.lib.hiPrio pkgs.orbstack;
          };
        in
        lib.attrValues (lib.removeAttrs all config.meta.packages.exclude);
    };
}
```

#### `features/work/mailerlite.nix` (new)

Wraps the upstream mailerlite flake's darwin + HM modules. **NOT imported by `base.nix`**. Hosts that want work config import `darwin.mailerlite` into their darwin module list and `homeManager.mailerlite` into `home-manager.sharedModules`.

```nix
{ inputs, ... }:
{
  flake.modules.darwin.mailerlite = { config, lib, ... }: {
    imports = [ inputs.mailerlite.modules.darwin.defaults ];

    config = lib.mkIf config.meta.work.enable {
      mailerlite.team = config.meta.work.team;
    };
  };

  flake.modules.homeManager.mailerlite = { config, lib, pkgs, ... }: {
    imports = [ inputs.mailerlite.modules.home-manager.defaults ];

    config = lib.mkIf config.meta.work.enable {
      meta.ssh.enable = lib.mkDefault true;

      mailerlite = {
        team = config.meta.work.team;
        direnv.enable = false;
        ssh.username = config.meta.username;
      };

      home.packages = inputs.mailerlite.pkgs.aarch64-darwin.${config.meta.work.team};
    };
  };
}
```

**Why the `imports = [ ... ]` is outside the `mkIf`**: nix module imports are evaluated statically and can't depend on `config`. The upstream mailerlite module is always imported when this feature file is imported — but hosts only import this feature when they actually want work config, so thebe (which doesn't import this feature) never evaluates the upstream module at all.

**Team is required**: if `meta.work.enable = true` but `meta.work.team = null`, the `home.packages = ...${null}` line will fail. Consider adding an `assertion` in a follow-up if you want a clearer error message; not a blocker.

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
      darwin.homeManager
      darwin.nixHomebrew

      # system category
      darwin.system
      darwin.dock
      darwin.finder
      darwin.fonts
      darwin.homebrew
      darwin.launchAgents
      darwin.preferences
      darwin.security
      darwin.services
      darwin.logiOptions       # cask: logi-options+
      darwin.cloudflareWarp    # cask: cloudflare-warp

      # developer category (darwin-side pieces)
      darwin.onePassword       # cask: 1password
      darwin.ghostty           # cask: ghostty
      darwin.vscode            # cask: visual-studio-code
      darwin.tableplus         # cask: tableplus
      darwin.medis             # cask: medis
      darwin.syntaxHighlight   # cask: syntax-highlight

      # desktop category
      darwin.brave             # cask: brave-browser
      darwin.hammerspoon       # cask: hammerspoon
      darwin.cleanshot         # cask: cleanshot
      darwin.swiftbar          # cask: swiftbar
      # NOTE: darwin.slack and darwin.zoom are NOT in base.nix.
      # They are imported directly by hosts/titan.nix.
    ];

    home-manager.sharedModules = [
      generic.meta

      # system category
      homeManager.hmWorkarounds

      # developer category
      homeManager.packagesCore
      homeManager.packagesLanguages
      homeManager.packagesOps
      homeManager.onePassword
      homeManager.ghostty
      homeManager.vscode
      homeManager.git
      homeManager.gh
      homeManager.direnv
      homeManager.claudeCode
      homeManager.zsh
      homeManager.neovim
      homeManager.zoxide
      homeManager.fd
      homeManager.doggo
      homeManager.k9s
      homeManager.ssh

      # desktop category
      homeManager.hammerspoon
    ];
  };
}
```

**work/mailerlite is deliberately absent** — it is opted into per-host.

### 4b. `modules/hosts/titan.nix`

```nix
{ config, ... }:
let
  inherit (config.flake.modules) darwin homeManager;
  meta = {
    work = {
      enable = true;
      team = "sre";
    };
    dockPathOverrides = {
      "/Applications/Beeper Desktop.app/" = "/Applications/Slack.app/";
    };
  };
in
{
  configurations.darwin.titan.module = {
    imports = [
      darwin.base
      darwin.slack          # titan-only feature (cask: slack)
      darwin.zoom           # titan-only feature (cask: zoom)
      darwin.mailerlite     # titan-only feature (work)
    ];
    inherit meta;

    home-manager.sharedModules = [
      homeManager.mailerlite
      { inherit meta; }
    ];
  };
}
```

Notes:
- `darwin.base` already adds `homeManager.*` features to `home-manager.sharedModules`. Titan only needs to append `homeManager.mailerlite` and the meta-setting module.
- `slack` and `zoom` are currently cask-only features, so they only appear in the darwin imports list. If future nix config adds a `homeManager.slack` module, titan's `home-manager.sharedModules` would need to import it too.
- `meta` is inherited into both the darwin tree and the HM sub-tree so features on both sides see the same values.
- No need to hardcode `inputs.mailerlite.pkgs.aarch64-darwin.sre` here — the feature derives it from `meta.work.team`.

### 4c. `modules/hosts/thebe.nix`

```nix
{ config, ... }:
let
  inherit (config.flake.modules) darwin;
in
{
  configurations.darwin.thebe.module = {
    imports = [
      darwin.base
      darwin.beeper          # thebe-only feature (cask: beeper)
    ];
    # No meta overrides needed — all defaults apply.
  };
}
```

Thebe gets all three package groups, default dock (Beeper — now actually installed via nix), no work config, no ssh config. `beeper` is a new cask introduced by this migration; see "Intentional Behavior Changes".

## Phase 5: Rewrite `flake.nix`

```nix
{
  description = "Bob's Nix configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    nix4vscode = {
      url = "github:nix-community/nix4vscode";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    lefthook = {
      url = "github:sudosubin/lefthook.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    claude-code-overlay.url = "github:nklmilojevic/claude-code-overlay";

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

After `flake.nix` is rewritten and features are in place, delete:

- `hosts.nix`
- `lib/` (entire directory, including `mkHost.nix`)
- `hosts/` (entire directory — the old `hosts/darwin/default.nix`)
- `modules/darwin/` (entire directory)
- `modules/shared/` (entire directory)

Leave intact:
- `overlays/`
- `pkgs/`
- `Taskfile.yml` and any CI config

## Phase 7: Verification (Eval Only — No Switch)

**Do not run `task build`, `darwin-rebuild switch`, or any activation command.** The user will perform the switch manually after reviewing the migration commit. Verification is strictly limited to evaluation.

1. `git add -A` — nix can only see staged files in a dirty worktree.
2. `nix flake check` — must pass. Expected checks: the lefthook-check, plus derivation evaluation for both `darwinConfigurations.titan` and `darwinConfigurations.thebe`.
3. `nix eval .#darwinConfigurations.titan.system.outPath` — forces full evaluation of the titan derivation (catches eval errors that `flake check` may skip).
4. `nix eval .#darwinConfigurations.thebe.system.outPath` — same for thebe.
5. **Stop here.** Do not build, do not switch, do not activate. Leave the branch in a state where the user can review and run `task build` themselves.

### Post-switch checks (for the user to run manually, not the implementer)

Once the user runs the switch, they should verify:
- Dock has Slack (not Beeper) on titan and the default (Beeper) on thebe, with all other pinned apps present.
- VS Code opens with the correct settings, keybindings, and extensions.
- `gh auth status` reachable, `git config user.email` is `rob@ruled.io`.
- SSH `~/.ssh/config` is regenerated on titan (should not exist on thebe).
- Mailerlite-specific commands work (team tooling).
- No `home-manager` warnings about pathsToLink or fonts.

## Behavior Preservation Notes

These must **not** change from current behavior. Executor should double-check each during implementation:

1. **`home.stateVersion = "25.05"`** — current value, not `"24.05"` as the original spec draft stated.
2. **`autoMigrate = true`, `mutableTaps = false`** — previous was `mutableTaps = true`; this is a deliberate lockdown.
3. **`backupFileExtension = "backup"`** — preserved in `modules/home-manager.nix`.
4. **`targets.darwin.linkApps.enable = false`** — preserved in `hmWorkarounds`.
5. **`home.file."Library/Fonts/.home-manager-fonts-version".enable = false`** — preserved in `hmWorkarounds`.
6. **`manual.manpages.enable = false`** — preserved in `hmWorkarounds`.
7. **`programs.man.generateCaches = false`** — preserved in `hmWorkarounds`.
8. **`enableNixpkgsReleaseCheck = false`** — preserved in `modules/home-manager.nix`.
9. **`php83Packages.composer` at `hiPrio` AND `php-cs-fixer`** — both must exist in the final `languages` package set.
10. **`orbstack` at `hiPrio`** — preserved in `ops`.
11. **`yq-go` at `hiPrio`** — preserved in `core`.
12. **VS Code cask** is installed via homebrew (not nixpkgs) because homebrew's VS Code allows mods. Do not switch to `pkgs.vscode`.
13. **VS Code `mcp.json`** is written via `home.file."Library/Application Support/Code/User/mcp.json"`. This workaround must survive the migration (upstream HM doesn't support `userMcp` yet).
14. **Titan's dock replacement** is Beeper→Slack, not the other way around.
15. **Statuline script** and `~/.local/bin/claude` symlink from `claude-code.nix` must be preserved exactly.
16. **All 14 existing homebrew casks must remain declared** in `modules/features/`: `1password`, `ghostty`, `brave-browser`, `hammerspoon`, `medis`, `slack`, `syntax-highlight`, `tableplus`, `zoom`, `logi-options+`, `visual-studio-code`, `cleanshot`, `swiftbar`, `cloudflare-warp`. Each must carry `greedy = true`. Verify with: `grep -rE 'name = "(1password|ghostty|brave-browser|hammerspoon|medis|slack|syntax-highlight|tableplus|zoom|logi-options|visual-studio-code|cleanshot|swiftbar|cloudflare-warp)"' modules/features/` — expect 14 matches, each with `greedy = true` nearby. `beeper` is a 15th, new cask (see "Intentional Behavior Changes").
17. **Titan still installs all 14 existing casks after migration.** 12 come via `base.nix`; `slack` and `zoom` come via explicit imports in `hosts/titan.nix`. Titan does **not** import `darwin.beeper`. If `slack` or `zoom` is missing from titan's imports list, homebrew will uninstall that app on the next switch because of `onActivation.cleanup = "uninstall"`.
18. **Thebe installs 13 casks after migration** — 12 from `base.nix` plus `beeper` via explicit import in `hosts/thebe.nix`. Thebe loses `slack` and `zoom` compared to its current state, and gains `beeper`. Both are deliberate changes (see "Intentional Behavior Changes").

## Intentional Behavior Changes

These are the *only* behavior changes in this migration, all explicitly decided:

1. **Drop `claudeCode.useVertex`** — user no longer uses Vertex. Remove both the meta option and the `claudeCode.disableLoginPrompt = true` line from `vscode/_config/user.nix`.
2. **`nix-homebrew.mutableTaps` flips from `true` to `false`** — CLI `brew tap foo/bar` will fail after this switches.
3. **Drop `modules/darwin/programs/wezterm/`** — already unused, removed with the rest of `modules/darwin/`.
4. **Thebe loses the `slack` and `zoom` casks** — currently both hosts install all 14 casks via `modules/darwin/homebrew.nix`. After migration, `slack.nix` and `zoom.nix` live as feature files but are **not** imported by `base.nix`; titan imports them explicitly, thebe does not. Because `homebrew.onActivation.cleanup = "uninstall"` is set, the first activation on thebe will uninstall Slack.app and zoom.us.app. If thebe needs either back, add `darwin.slack` / `darwin.zoom` (and matching `homeManager.*` imports if HM config is later added) to `hosts/thebe.nix`.
5. **Thebe gains the `beeper` cask** — new feature `features/desktop/beeper.nix` with cask `beeper` (greedy). **Not** in `base.nix`; imported only by `hosts/thebe.nix`. Titan does not import it, so Beeper will not be installed on titan (titan's dock continues to override `/Applications/Beeper Desktop.app/` → `/Applications/Slack.app/`, which is a path rewrite and does not require Beeper to actually exist on disk). On thebe's first activation after the switch, homebrew will install Beeper Desktop, and thebe's default dock (which references Beeper) will now point to a real installed app instead of a missing one.

## Execution Note

This migration is **atomic** — the flake either uses the old pattern or the new one. It cannot be split into independent worktrees that merge separately. Implement sequentially on a single branch, with one final commit containing all changes. Intermediate states between phases will not `nix flake check` cleanly; that's expected.

## Acceptance Criteria

- [ ] `nix flake check` passes.
- [ ] `nix eval .#darwinConfigurations.titan.system.outPath` succeeds.
- [ ] `nix eval .#darwinConfigurations.thebe.system.outPath` succeeds.
- [ ] **No `task build`, `darwin-rebuild switch`, or any activation command was run** — the user performs the switch manually afterwards.
- [ ] `hosts.nix`, `lib/`, `hosts/darwin/`, `modules/darwin/`, `modules/shared/` are all deleted.
- [ ] No file outside `overlays/`, `pkgs/`, `modules/`, `flake.{nix,lock}` is touched.
- [ ] All items in "Behavior Preservation Notes" verified by inspection (not by switching).
- [ ] All five items in "Intentional Behavior Changes" applied.
