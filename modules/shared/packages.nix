{ pkgs, hostConfig ? { extraHomeManagerPackages = [ ]; } }:
with pkgs;
[
  # Tools
  curl
  wget
  ripgrep
  openssl
  jq
  # Replace yq-go with configured version to avoid collisions
  (pkgs.symlinkJoin {
    name = "yq-go-priority";
    paths = [ yq-go ];
    # Give this a higher priority than the Python version
    meta.priority = 1;
  })
  fzf
  git
  sops
  age
  mtr
  netcat
  socat
  nmap
  restic
  statix
  ansible-lint
  nixpkgs-fmt
  poetry
  hugo
  ffmpeg-full
  flyctl
  minio-client
  go-task
  chart-testing
  cmctl
  swaks
  ncdu
  gdu
  graphviz
  uv
  parallel
  doctl
  ngrok
  todo-txt-cli
  (octodns.withProviders (_: [
    octodns.providers.cloudflare
  ]))
  wireguard-tools

  # Security
  gnupg
  yubikey-manager
  pinentry_mac

  # Linters
  golangci-lint

  # SaaS tools
  gh
  (google-cloud-sdk.withExtraComponents [
    google-cloud-sdk.components.gke-gcloud-auth-plugin
  ])
  _1password-cli
  opentofu
  spacectl
  awscli2

  # Languages (not modularized)
  cue
  go
  cargo

  # Infrastructure
  docker
  caddy
  tailscale

  # Shell tools
  eza # Better ls
  bat # Better cat
  ripgrep # Better grep
  fd # Better find
  procs # Better ps
  stable.direnv
  nix-direnv
  pre-commit
  nix-your-shell
  kcl
  lefthook
  slides

  # Custom
  # ml
  menu
] ++ hostConfig.extraHomeManagerPackages
