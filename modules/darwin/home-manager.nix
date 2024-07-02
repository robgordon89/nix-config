{ config, pkgs, lib, home-manager, ... }:

let
  user = "robert";
in
{
     documentation.man.enable = false;
}
