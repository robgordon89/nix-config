{ config
, inputs
, lib
, pkgs
, outputs
, configLib
, ...
}:
{
  imports = lib.flatten [
    inputs.krewfile.homeManagerModules.krewfile
    (configLib.scanPaths ./.)
  ];

  home = {
    username = lib.mkDefault "robert";
    homeDirectory = lib.mkDefault "/Users/${config.home.username}";
    stateVersion = lib.mkDefault "23.05";
    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/scripts/talon_scripts"
    ];
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
      zoxide
      pre-commit
      nix-your-shell
      kcl
    ];
  };

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  programs = {
    home-manager.enable = true;
  };
}
