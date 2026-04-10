{ ... }:
{
  flake.modules.homeManager.packagesOps = { config, lib, pkgs, ... }:
    lib.mkIf (lib.elem "ops" config.meta.packages.groups) {
      home.packages =
        let
          all = {
            inherit (pkgs)
              kubectl-df-pv kubectx fluxcd kubeconform kubernetes-helm
              skaffold caddy kubebuilder tailscale cilium-cli
              ;
            orbstack = pkgs.lib.hiPrio pkgs.orbstack;
          };
        in
        lib.attrValues (lib.removeAttrs all config.meta.packages.exclude);
    };
}
