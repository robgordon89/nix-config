{ config, ... }:
let
  inherit (config.flake.modules) darwin;
in
{
  configurations.darwin.thebe.module = {
    imports = [
      darwin.base
      darwin.beeper
    ];
  };
}
