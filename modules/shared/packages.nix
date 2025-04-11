{ pkgs }:
with pkgs; [
  # Tools
  curl
  wget
  ripgrep
  openssl
  jq
  yq
  fzf
  git
  sops
  age
  mtr
  netcat
  socat
  nmap
  gnupg
  restic
  eza
  statix
  ansible-lint
  devenv
  nixpkgs-fmt
  terraform
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

  # SaaS tools
  gh
  (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.gke-gcloud-auth-plugin ])
  _1password-cli
  opentofu
  spacectl

  # Python
  (python312.withPackages (p: [
    p.llm
    p.llm-ollama
    p.pyyaml
    p.llm-cmd
    p.ruff
    p.ansible-core
    p.git-filter-repo
    llm-openrouter
  ]))

  # Others
  nodejs_22
  typescript
  yarn
  bun
  cue
  go
  php83
  php83Packages.deployer
  php83Packages.composer
  php83Packages.php-cs-fixer

  # Databases
  clickhouse
  postgresql_16
  mariadb
  redis

  # Containers and virtualization
  docker
  k9s
  kubectl
  kubectx
  fluxcd
  kubeconform
  kubernetes-helm
  skaffold
  caddy
  kubebuilder

  # Shell tools
  direnv
  nix-direnv
  pre-commit
  nix-your-shell
  kcl

  # Custom
  ml
]
