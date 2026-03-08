{ config, lib, pkgs, ... }:

let
  inherit (lib) mkOption mkEnableOption mkIf types;
  cfg = config.programs.phpEnv;
in
{
  options.programs.phpEnv = {
    enable = mkEnableOption "PHP development environment";

    package = mkOption {
      type = types.package;
      default = pkgs.php83;
      description = "PHP package to use.";
    };

    composer = mkOption {
      type = types.bool;
      default = true;
      description = "Install Composer.";
    };

    phpCsFixer = mkOption {
      type = types.bool;
      default = true;
      description = "Install PHP CS Fixer.";
    };

    deployer = mkOption {
      type = types.bool;
      default = true;
      description = "Install Deployer.";
    };

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = "Extra PHP related packages.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs;
      [ cfg.package ]
      ++ (lib.optional cfg.composer (lib.hiPrio php83Packages.composer))
      ++ (lib.optional cfg.phpCsFixer php83Packages.php-cs-fixer)
      ++ (lib.optional cfg.deployer deployer)
      ++ cfg.extraPackages;
  };
}
