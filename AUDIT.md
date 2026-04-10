# Nix Flake Audit & Migration Plan

## 1. Bugs

### Typo in jankyborders style
- **File**: `modules/darwin/services.nix:7`
- **Issue**: `style = "sqaure"` should be `"square"`

### Duplicate package entry
- **File**: `modules/shared/packages.nix`
- **Issue**: `todo-txt-cli` listed twice (lines 51 and 138)

### Broken overlay reference
- **File**: `hosts/darwin/default.nix:33`
- **Issue**: `outputs.overlays.default` tries to access `.default` on a list. `overlays/default.nix` returns a flat list of overlay functions, not an attrset. This is either silently broken or dead code since `mkHost.nix` already passes a pre-configured `pkgs` with overlays applied (bypassing `nixpkgs.overlays`).
- **Fix**: Make `overlays/default.nix` return an attrset with a `default` key using `lib.composeManyExtensions`, or remove the broken reference from `hosts/darwin/default.nix`.

---

## 2. Dead Code

| What | Where | Why it's dead |
|---|---|---|
| `nixpkgs-unstable` input | `flake.nix:8` | Never referenced anywhere. Main `nixpkgs` already tracks unstable. |
| `lib/default.nix` | `lib/default.nix` | Exports `mkHost` but `flake.nix` imports `./lib/mkHost.nix` directly. |
| `pkgs/ml/package.nix` | `pkgs/ml/` | Commented out in `shared/packages.nix:142` — moved to mailerlite flake. |
| `plugins = [ ]` | `modules/shared/programs/zsh/default.nix:109` | Empty list, no effect. |
| Eza fallback pattern | `modules/shared/programs/zsh/default.nix:36-39` | `(if pkgs ? eza then "" else "ls")` always evaluates to `""` since eza is always in nixpkgs. Same for bat, fd, procs aliases. |
| `lastDownload` timestamp | `modules/darwin/programs/vscode/config/user.nix:188` | `"php-cs-fixer.lastDownload" = 1715169674762` is a stale timestamp that has no effect. |

---

## 3. Duplicate Packages

Packages that appear in `modules/shared/packages.nix` AND in individual program modules (via `home.packages` or `programs.*.enable`). Remove from `packages.nix` — the program modules handle them.

| Package | In `packages.nix` | Also provided by |
|---|---|---|
| `ripgrep` | Line 11 | `modules/shared/programs/neovim/default.nix:45` |
| `fd` | Line 128 | `modules/shared/programs/neovim/default.nix:46` + `programs.fd` in `fd.nix` |
| `nodejs_22` | Line 98 | `modules/shared/programs/neovim/default.nix:50` |
| `gh` | Line 66 | `modules/shared/programs/neovim/default.nix:51` + `programs.gh` in `gh.nix` |
| `k9s` | Line 124 | `programs.k9s` in `modules/shared/programs/k9s.nix` |
| `direnv` + `nix-direnv` | Lines 131-132 | `programs.direnv` in `modules/shared/programs/direnv.nix` |
| `todo-txt-cli` | Lines 51 AND 138 | Duplicate of itself |

---

## 4. Flake Input Bloat

`flake.lock` has **26 nodes** including 4 duplicate nixpkgs evaluations (`nixpkgs`, `nixpkgs_2`, `nixpkgs_3`, `nixpkgs_4`) and 3 duplicate `systems` entries.

| Input | Issue | Fix |
|---|---|---|
| `nixpkgs-unstable` | Never used | Remove entirely |
| `lefthook` | Only used for devShell check | Consider if `nixpkgs.lefthook` is sufficient and drop the input |

After fixing follows and removing unused inputs, `flake.lock` should drop from 26 to ~18-20 nodes and eliminate redundant nixpkgs evaluations.

---

## 5. Anti-Patterns

### `with pkgs;` usage
- **Files**: `modules/shared/packages.nix:8`, `modules/darwin/packages.nix:3`
- **Issue**: Obscures which packages come from where, makes dependencies implicit.
- **Fix**: Use explicit `pkgs.` prefix or `inherit (pkgs)` for clarity.

### `callPackage` on a non-derivation
- **File**: `modules/darwin/home-manager.nix:33`
- **Issue**: `pkgs.callPackage ./packages.nix { inherit hostConfig; }` works but is semantically wrong. `callPackage` is intended for derivations. This is just a list of packages.
- **Fix**: Use a plain `import ./packages.nix { inherit pkgs hostConfig; }`.

### `specialArgs` threading
- **Issue**: `hostConfig` is threaded through every module via `specialArgs`. Every module must declare `hostConfig` in its arguments. Creates implicit coupling.
- **Fix**: Consider converting to module options (or adopt dendritic pattern, see section 8).

### Stale workaround
- **File**: `modules/darwin/home-manager.nix:46`
- **Issue**: Comment says "Marked broken Oct 20, 2022 check later to remove this" referencing [home-manager#3344](https://github.com/nix-community/home-manager/issues/3344). This is 3.5 years old — check if still needed and remove if resolved.

### yq-go priority wrapper
- **File**: `modules/shared/packages.nix:16-20`
- **Issue**: Uses `symlinkJoin` to set priority. Could use `lib.hiPrio` like orbstack and composer already do elsewhere in the same file.

---

## 6. Evaluation Performance

### Full nixpkgs-stable evaluation for one package
- **File**: `overlays/stable-packages.nix`
- **Issue**: Instantiates an entire separate nixpkgs evaluation just to provide `pkgs.stable.direnv`. This adds significant evaluation time.
- **Fix**: Pin direnv to a specific version directly, or accept the cost if more stable packages are planned.

### `ignoreCollisions = true` in Python env
- **File**: `modules/shared/packages.nix:95`
- **Issue**: Silently masks real package conflicts in the Python environment. If two packages ship the same binary, you won't know which wins.
- **Fix**: Identify and resolve the actual collision, then remove `ignoreCollisions`.

---

## 7. Quick Structural Improvements (no dendritic)

### Fix overlay type
Make `overlays/default.nix` return a proper attrset:
```nix
{ inputs, ... }:
let
  overlayFiles = builtins.filter (file: file != "default.nix") (builtins.attrNames (builtins.readDir ./.));
  overlayList = map (file: import ./${file} { inherit inputs; }) overlayFiles;
in
{
  default = final: prev:
    builtins.foldl' (acc: overlay: acc // (overlay final prev)) {} overlayList;
}
```

### Consolidate documentation.nix
The two separate `documentation` blocks can be merged into one:
```nix
{ ... }:
{
  documentation = {
    enable = false;
    doc.enable = false;
    info.enable = false;
    man.enable = false;
  };
}
```

### Clean up zsh aliases
Remove the dead fallback pattern from all aliases:
```nix
# Before (dead fallback)
ls = "${pkgs.eza}/bin/eza --group-directories-first" + (if pkgs ? eza then "" else "ls");

# After
ls = "${pkgs.eza}/bin/eza --group-directories-first";
```

---

## 8. Dendritic Migration Assessment

[Dendritic](https://github.com/mightyiam/dendritic) is a flake-parts-based architecture pattern where every file is a top-level flake-parts module, and lower-level configurations (nix-darwin, home-manager) are stored as `deferredModule` option values.

### What you'd gain

- **Feature-based file organization**: A single `fonts.nix` would contain darwin font packages AND ghostty/vscode font config, instead of scattering font concerns across 3+ files.
- **No `specialArgs` threading**: Shared values (username, email, sshPublicKey) become top-level options (e.g. `config.meta.username`) accessible from any module without argument passing.
- **Auto-import via `import-tree`**: No manual import lists to maintain. Adding a new `.nix` file to `modules/` automatically includes it.
- **Cleaner host differentiation**: Titan vs Thebe would compose named deferred module fragments rather than using `extraConfig`/`extraDarwinModules`/`extraHomeManagerModules` bags.
- **Eliminates `mkHost.nix`**: Host building logic moves into flake-parts module composition.

### What it costs

- **New dependencies**: `flake-parts` + `import-tree` added to flake inputs.
- **Learning curve**: Understanding `deferredModule` type, flake-parts module system, and how deferred modules merge.
- **Full rewrite**: Every file changes. Similar-sized repos report ~300 file changes in the adoption commit.
- **Debugging indirection**: Error traces go through deferred module merging instead of a direct import chain.

### Example: current vs dendritic

**Current** — font config is split across layers:
```
modules/darwin/fonts.nix          → system font packages
modules/darwin/programs/ghostty/  → font-family = TX-02
modules/darwin/programs/vscode/config/user.nix → editor.fontFamily = TX-02
```

**Dendritic** — one file per feature:
```nix
# modules/fonts.nix (a flake-parts module)
{ ... }:
{
  flake.modules = {
    darwin.shared = { pkgs, ... }: {
      fonts.packages = with pkgs; [ nerd-fonts.fira-code geist-font ];
    };
    homeManager.shared = { config, ... }: {
      # ghostty font config
      home.file."${config.xdg.configHome}/ghostty/config".text = ''
        font-family = TX-02
        ...
      '';
      # vscode font config handled in a separate editor.nix
    };
  };
}
```

### Recommendation

The current config is small (48 nix files, 2 hosts, clean separation). Dendritic pays off more with many hosts, multiple configuration classes, and heavy cross-cutting concerns.

**Recommended approach:**
1. Implement sections 1-7 first (bugs, dead code, deduplication, follows, anti-patterns)
2. Revisit dendritic if/when adding NixOS hosts or cross-cutting pain increases
3. If migrating, do it in one atomic commit — incremental adoption is not practical

---

## Implementation Priority

| Priority | Section | Effort | Impact |
|---|---|---|---|
| P0 | 1. Bugs | 10 min | Correctness |
| P1 | 2. Dead code removal | 20 min | Cleanliness, reduced eval surface |
| P1 | 3. Deduplicate packages | 10 min | Faster builds, clarity |
| P1 | 4. Fix input follows | 5 min | Fewer nixpkgs evals, faster lock updates |
| P2 | 5. Anti-patterns | 30 min | Code quality |
| P2 | 6. Eval performance | 15 min | Faster `nix build` |
| P2 | 7. Structural improvements | 30 min | Maintainability |
| P3 | 8. Dendritic migration | 2-4 hours | Architecture |
