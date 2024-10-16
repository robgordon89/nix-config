# default recipe to display help information
default:
  @just --list

rebuild-pre:
  git add *.nix

check:
  nix flake check --impure --keep-going
  cd nixos-installer && nix flake check --impure --keep-going

check-trace:
  nix flake check --impure --show-trace
  cd nixos-installer && nix flake check --impure --show trace

# Add --option eval-cache false if you end up caching a failure you can't get around
rebuild: rebuild-pre
  scripts/system-flake-rebuild.sh

rebuild-full: rebuild-pre
  scripts/system-flake-rebuild.sh

update:
  nix flake update

rebuild-update: update && rebuild

diff:
  git diff ':!flake.lock'
