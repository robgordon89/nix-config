#FIXME: Move attrs that will only work on linux to nixos.nix
{ config
, lib
, pkgs
, hostSpec
, ...
}:
let
  platform = if hostSpec.isDarwin then "darwin" else "nixos";
in
{
  imports = lib.flatten [
    (map lib.custom.relativeToRoot [
      "modules/common/host-spec.nix"
      "modules/home-manager"
    ])
    ./${platform}.nix
    ./git
    ./zsh
    ./neovim
    ./fd.nix
    ./k9s.nix
    ./zoxide.nix
  ];

  inherit hostSpec;

  home = {
    username = lib.mkDefault config.hostSpec.username;
    homeDirectory = lib.mkDefault config.hostSpec.home;
    stateVersion = lib.mkDefault "23.05";
    # TODO: tidy up this when 25.05 is merged
    enableNixpkgsReleaseCheck = false;
    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/scripts/talon_scripts"
    ];
    sessionVariables = {
      FLAKE = "$HOME/nix-config";
      VISUAL = "nvim";
      EDITOR = "nvim";
    };
    packages = with pkgs; [
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
      nmap
      gnupg
      restic
      eza
      statix
      ansible-lint
      devenv
      nixpkgs-fmt
      bob
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

      # SaaS tools
      gh
      (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.gke-gcloud-auth-plugin ])
      _1password-cli
      opentofu
      spacectl

      # Programming languages
      python312
      python312Packages.ansible-core
      nodejs_22
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

      # Shell tools
      direnv
      nix-direnv
      pre-commit
      nix-your-shell
      kcl
    ];
  };

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = false;
    };
  };

  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
