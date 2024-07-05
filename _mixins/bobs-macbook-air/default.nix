{ config, lib, platform, hostname, pkgs, ... }:

{
  imports = [
    ../../modules/home-manager.nix
    ../../modules/packages.nix
  ];

  # Here we can override any options from the imported modules
  # Becuase we set mkDefault in the host module, we can override it here
  user.name = "robert";
}
