{ config, lib, pkgs, ... }:

let
  inherit (lib) mkOption mkEnableOption mkIf types;
  cfg = config.programs.kubernetes;
in
{
  options.programs.kubernetes = {
    enable = mkEnableOption "Kubernetes tooling";

    tools = {
      kubectl = mkOption {
        type = types.bool;
        default = true;
        description = "Install kubectl.";
      };

      k9s = mkOption {
        type = types.bool;
        default = true;
        description = "Install k9s terminal UI.";
      };

      kubectx = mkOption {
        type = types.bool;
        default = true;
        description = "Install kubectx/kubens context switcher.";
      };

      helm = mkOption {
        type = types.bool;
        default = true;
        description = "Install Helm package manager.";
      };

      fluxcd = mkOption {
        type = types.bool;
        default = true;
        description = "Install FluxCD CLI.";
      };

      skaffold = mkOption {
        type = types.bool;
        default = false;
        description = "Install Skaffold.";
      };

      kubebuilder = mkOption {
        type = types.bool;
        default = false;
        description = "Install Kubebuilder.";
      };

      cilium = mkOption {
        type = types.bool;
        default = false;
        description = "Install Cilium CLI.";
      };

      kubeconform = mkOption {
        type = types.bool;
        default = true;
        description = "Install Kubeconform for manifest validation.";
      };

      kubectlDfPv = mkOption {
        type = types.bool;
        default = true;
        description = "Install kubectl-df-pv plugin.";
      };
    };

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = "Extra Kubernetes-related packages to install.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs;
      (lib.optional cfg.tools.kubectl kubectl)
      ++ (lib.optional cfg.tools.k9s k9s)
      ++ (lib.optional cfg.tools.kubectx kubectx)
      ++ (lib.optional cfg.tools.helm kubernetes-helm)
      ++ (lib.optional cfg.tools.fluxcd fluxcd)
      ++ (lib.optional cfg.tools.skaffold skaffold)
      ++ (lib.optional cfg.tools.kubebuilder kubebuilder)
      ++ (lib.optional cfg.tools.cilium cilium-cli)
      ++ (lib.optional cfg.tools.kubeconform kubeconform)
      ++ (lib.optional cfg.tools.kubectlDfPv kubectl-df-pv)
      ++ cfg.extraPackages;
  };
}
