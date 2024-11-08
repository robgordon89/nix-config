{ inputs, pkgs, ... }:

{
  programs.krewfile = {
    enable = false;
    krewPackage = pkgs.krew;
    indexes = {
      default = "https://github.com/kubernetes-sigs/krew-index.git";
      netshoot = "https://github.com/nilic/kubectl-netshoot.git";
    };
    plugins = [
      "netshoot/netshoot"
      "df-pv"
      "ctx"
      "ns"
      "kluster-capacity"
      "konfig"
      "krew"
      "node-shell"
      "pv-migrate"
      "view-secret"
      "view-allocations"
      "view-cert"
      "view-secret"
      "view-utilization"
      "tree"
    ];
  };
}
