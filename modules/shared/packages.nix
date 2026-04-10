{
  pkgs,
  hostConfig ? {
    extraHomeManagerPackages = [ ];
  },
}:
with pkgs;
[
  # Tools
  curl
  wget
  openssl
  jq
  (pkgs.lib.hiPrio yq-go)
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
    ];
  })

  # Others
  typescript
  yarn
  bun
  cue
  go
  php83
  deployer
  (pkgs.lib.hiPrio php83Packages.composer)
  php83Packages.php-cs-fixer
  cargo

  # Containers and virtualization
  # docker
  (pkgs.lib.hiPrio orbstack)
  # kubectl
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
  procs # Better ps
  pre-commit
  nix-your-shell
  kcl
  lefthook
  slides
]
++ hostConfig.extraHomeManagerPackages
