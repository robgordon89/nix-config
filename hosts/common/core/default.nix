{
  pkgs,
  lib,
  inputs,
  outputs,
  configLib,
  configVars,
  ...
}:
let
  #FIXME:(configLib) switch this and other instances to configLib function
  homeDirectory =
    if pkgs.stdenv.isLinux then "/home/${configVars.username}" else "/Users/${configVars.username}";
in
{
  imports = lib.flatten [
    (configLib.scanPaths ./.)
    (configLib.relativeToRoot "hosts/common/users/${configVars.username}")
    # inputs.home-manager.nixosModules.home-manager
    # (builtins.attrValues outputs.nixosModules)
  ];

  # programs.nh = {
  #   enable = true;
  #   clean.enable = true;
  #   clean.extraArgs = "--keep-since 20d --keep 20";
  #   flake = "${homeDirectory}/nix-config";
  # };

  # This should be handled by config.security.pam.sshAgentAuth.enable
  # security.sudo.extraConfig = ''
  #   Defaults lecture = never # rollback results in sudo lectures after each reboot, it's somewhat useless anyway
  #   Defaults pwfeedback # password input feedback - makes typed password visible as asterisks
  #   Defaults timestamp_timeout=120 # only ask for password every 2h
  #   # Keep SSH_AUTH_SOCK so that pam_ssh_agent_auth.so can do its magic.
  #   Defaults env_keep+=SSH_AUTH_SOCK
  # '';

  home-manager.extraSpecialArgs = {
    inherit inputs outputs;
  };

  nixpkgs = {
    # you can add global overlays here
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
    };
  };

  # hardware.enableRedistributableFirmware = true;
}
