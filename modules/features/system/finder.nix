{ ... }:
{
  flake.modules.darwin.finder = {
    system.defaults.finder = {
      ShowPathbar = false;
      NewWindowTarget = "Home";
      _FXSortFoldersFirst = true;
      FXDefaultSearchScope = "SCcf";
      FXEnableExtensionChangeWarning = false;
      ShowStatusBar = false;
      # Default view for new/unconfigured windows: "icnv" = Icon (grid) view.
      # (Other values: "Nlsv" list, "clmv" column, "Flwv" gallery.)
      FXPreferredViewStyle = "icnv";
    };

    # ShowSidebar isn't exposed as a typed finder option, so set it raw.
    system.defaults.CustomUserPreferences."com.apple.finder" = {
      ShowSidebar = true;
    };
  };
}
