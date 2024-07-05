{ config, lib, platform, hostname, pkgs, ... }:

{
  imports = [
    ../_mixins/${lib.strings.toLower hostname}
  ];

  # Set the default user.name
  user.name = lib.mkDefault "robert";
}
