{ pkgs }:
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

  # AI tools
  claude-code
  cursor-cli
  codex
  gemini-cli

  # Python
  (python313.buildEnv.override {
    extraLibs = with python313.pkgs; [
      # Tools
      pyyaml
      ruff
      ansible-core
      git-filter-repo

      # LLM tools
      llm
      llm-ollama
      llm-cmd

      # Custom package
      pkgs.llm-openrouter
    ];
    ignoreCollisions = true;
  })

  # Others
  nodejs_22
  typescript
  yarn
  bun
  cue
  go
  php83
  deployer
  php83Packages.composer
  php83Packages.php-cs-fixer

  # Databases
  # clickhouse
  # postgresql_16
  # mariadb
  # redis

  # Containers and virtualization
  docker
  k9s
  kubectl
  kubectl-df-pv
  kubectx
  fluxcd
  kubeconform
  kubernetes-helm
  skaffold
  caddy
  kubebuilder
  tailscale
  cilium-cli

  # Shell tools
  eza # Better ls
  bat # Better cat
  ripgrep # Better grep
  fd # Better find
  procs # Better ps
  direnv
  nix-direnv
  pre-commit
  nix-your-shell
  kcl
  lefthook

  # Custom
  ml
  menu
]
