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
              restic ansible-lint nixpkgs-fmt poetry
              go-task chart-testing cmctl swaks ncdu gdu
              graphviz uv parallel doctl ngrok wireguard-tools
              tart
              ;
            yq-go = pkgs.lib.hiPrio pkgs.yq-go;
            octodns = pkgs.octodns.withProviders (_: [ pkgs.octodns.providers.cloudflare ]);

            # Security
            inherit (pkgs) gnupg yubikey-manager pinentry_mac;

            # Linters
            inherit (pkgs) golangci-lint;

            # AI tools
            inherit (pkgs) claude-code;

            # SaaS / cloud
            _1password-cli = pkgs._1password-cli;
            inherit (pkgs) opentofu spacectl;
            google-cloud-sdk = pkgs.google-cloud-sdk.withExtraComponents [
              pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin
            ];

            # Shell tools
            inherit (pkgs) eza bat procs pre-commit nix-your-shell kcl lefthook;
          };
        in
        lib.attrValues (lib.removeAttrs all config.meta.packages.exclude);
    };
}
