{ ... }:
{
  flake.modules.darwin.brave = { pkgs, ... }:
    let
      # Force-install the 1Password extension via Chromium managed policy.
      # ID is the Chrome Web Store extension id; update URL is the standard CRX feed.
      bravePolicy = pkgs.writeText "com.brave.Browser.plist" ''
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
          <key>ExtensionSettings</key>
          <dict>
            <key>aeblfdkhhhdcdjpifhhbdiojplfjncoa</key>
            <dict>
              <key>installation_mode</key>
              <string>force_installed</string>
              <key>update_url</key>
              <string>https://clients2.google.com/service/update2/crx</string>
              <key>toolbar_pin</key>
              <string>force_pinned</string>
            </dict>
          </dict>
        </dict>
        </plist>
      '';
    in
    {
      homebrew.casks = [ { name = "brave-browser"; greedy = true; } ];

      # Chromium only honors ExtensionInstallForcelist as a *mandatory* policy,
      # which on macOS means it must live in /Library/Managed Preferences/.
      # The user-domain (CustomUserPreferences) only yields recommended level,
      # which force-install ignores.
      system.activationScripts.postActivation.text = ''
        mkdir -p "/Library/Managed Preferences"
        cp -f ${bravePolicy} "/Library/Managed Preferences/com.brave.Browser.plist"
      '';
    };
}
