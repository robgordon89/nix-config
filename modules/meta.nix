{ ... }:
{
  flake.modules.generic.meta = { lib, config, ... }: {
    options.meta = {
      username = lib.mkOption {
        type = lib.types.str;
        default = "robert";
        description = "Unix username. Used for home dir, dock, ssh, etc.";
      };
      firstName = lib.mkOption {
        type = lib.types.str;
        default = "Robert";
      };
      lastName = lib.mkOption {
        type = lib.types.str;
        default = "Gordon";
      };
      fullName = lib.mkOption {
        type = lib.types.str;
        default = "${config.meta.firstName} ${config.meta.lastName}";
        defaultText = lib.literalExpression ''"''${config.meta.firstName} ''${config.meta.lastName}"'';
      };
      email = lib.mkOption {
        type = lib.types.str;
        default = "rob@ruled.io";
      };
      sshPublicKey = lib.mkOption {
        type = lib.types.str;
        default = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEJOD+xGS8a9Q2Dyyah+jH6caM2n4XaJNKRvmbo7NqaY";
        description = "Public key used for git commit signing.";
      };

      dockPathOverrides = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = { };
        description = ''
          Map of app path substitutions for the dock, e.g.
          { "/Applications/Beeper Desktop.app/" = "/Applications/Slack.app/"; }
        '';
      };
      dock = lib.mkOption {
        type = lib.types.attrs;
        default = { };
        description = "Host-specific raw overrides for system.defaults.dock (priority 80).";
      };

      ssh = {
        enable = lib.mkEnableOption "managed ~/.ssh/config generation";
        username = lib.mkOption {
          type = lib.types.str;
          default = config.meta.username;
          defaultText = lib.literalExpression "config.meta.username";
        };
        includeOrbstack = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
        use1PasswordAgent = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
        extraConfig = lib.mkOption {
          type = lib.types.lines;
          default = "";
        };
      };

      work = {
        enable = lib.mkEnableOption "work (mailerlite) configuration";
        team = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "Mailerlite team identifier (e.g., \"sre\"). Required when work.enable = true.";
        };
      };

      packages = {
        groups = lib.mkOption {
          type = lib.types.listOf (lib.types.enum [ "core" "languages" "ops" ]);
          default = [ "core" "languages" "ops" ];
          description = "Package groups to include on this host.";
        };
        exclude = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = ''
            Nix attribute names to exclude from any package group's set.
            Names must match the attribute key used inside the group file's
            package attrset (not the derivation pname).
          '';
        };
      };
    };
  };
}
