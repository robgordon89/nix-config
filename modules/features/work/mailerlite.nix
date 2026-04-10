{ inputs, ... }:
{
  flake.modules.darwin.mailerlite = { config, lib, ... }: {
    imports = [ inputs.mailerlite.modules.darwin.defaults ];

    config = lib.mkIf config.meta.work.enable {
      mailerlite.team = config.meta.work.team;
    };
  };

  flake.modules.homeManager.mailerlite = { config, lib, pkgs, ... }: {
    imports = [ inputs.mailerlite.modules.home-manager.defaults ];

    config = lib.mkIf config.meta.work.enable {
      meta.ssh.enable = lib.mkDefault true;

      mailerlite = {
        team = config.meta.work.team;
        direnv.enable = false;
        ssh.username = config.meta.username;
      };

      home.packages = inputs.mailerlite.pkgs.aarch64-darwin.${config.meta.work.team};
    };
  };
}
