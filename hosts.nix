{ mailerlite, ... }:
{
  titan = {
    extraConfig = { };
    extraModules = [
      mailerlite.darwinModules.home-manager
      {
        mailerlite.username = "robert";
        mailerlite.useDefaultSSHConfig = true;
      }
    ];
  };
  thebe = {
    extraConfig = { };
    extraModules = [ ];
  };
}
