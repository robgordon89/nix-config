# nix-config

nix-darwin + home-manager for two Apple Silicon Macs, built with flake-parts +
import-tree (dendritic pattern).

## Hosts

- **europa** — work (MailerLite SRE). Sets `meta.work`, adds Slack/Zoom and the
  modules from the `mailerlite` flake input.
- **thebe** — personal. `darwin.base` only.

Defined in `modules/hosts/`. `task build` resolves the host from the machine's
ComputerName, so the attr name must match the hostname.

## Layout

- `modules/` — every `.nix` file here is imported automatically; paths starting
  with `_` are skipped (`_config/` holds dotfiles and split-out settings).
- `modules/meta.nix` — the `meta.*` options (username, work, dock, hammerspoon,
  packages…). Per-host differences belong here as options, not as host branches.
- `modules/base.nix` — the shared host: which darwin and home-manager modules
  get imported.
- `modules/features/{system,developer,desktop,work}/` — one module per app or
  concern.
- `overlays/`, `pkgs/` — package overrides and local derivations.

## Adding a module

```nix
{ ... }:
{
  flake.modules.darwin.foo = { homebrew.casks = [ "foo" ]; };
  flake.modules.homeManager.foo = { ... };
}
```

Then list `darwin.foo` / `homeManager.foo` in `modules/base.nix`. Gate optional
parts with `lib.mkIf config.meta.<option>`.

Packages go in `modules/features/developer/packages/{core,languages,ops}.nix`;
a cask belongs to the module that owns the app.

## Workflow

- `task build` — build and switch (refreshes the `mailerlite`,
  `claude-code-overlay` and `sofka` inputs first)
- `task update` / `task update-build` — update `flake.lock`
- `nix flake check`
- `git add` new files before building — Nix ignores untracked files and the
  failure looks like the file doesn't exist.
- `nixfmt` runs on staged `.nix` files via lefthook.
