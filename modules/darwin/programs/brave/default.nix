{ pkgs, ... }:
{
  programs.chromium = {
    enable = true;
    package = pkgs.brave;
    extensions = [
      { id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa"; } # 1password
    ];
    # commandLineArgs = [
    #   "--disable-features=WebRtcAllowInputVolumeAdjustment"
    # ];
  };
}
