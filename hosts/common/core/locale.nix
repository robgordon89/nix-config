{ lib, ... }:
{
  environment.variables = {
    LANG = "en_GB.UTF-8";
  };
  time.timeZone = lib.mkDefault "America/Edmonton";
}
