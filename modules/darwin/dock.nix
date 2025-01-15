{ ... }:

{
  # Set some user preferences
  system.defaults.dock = {
    autohide = true;
    minimize-to-application = true;
    show-process-indicators = true;
    show-recents = false;
    static-only = false;
    showhidden = false;
    tilesize = 48;
    wvous-bl-corner = 1;
    wvous-br-corner = 1;
    wvous-tl-corner = 1;
    wvous-tr-corner = 1;
    persistent-apps = [
      "/Applications/Brave Browser.app/"
      "/Applications/Visual Studio Code.app/"
      "/Applications/WezTerm.app/"
      "/Applications/Slack.app/"
      "/Applications/1Password.app/"
      "/Applications/TablePlus.app/"
    ];
    persistent-others = [ "/Applications" "/Users/robert/Downloads" ];
  };
}
