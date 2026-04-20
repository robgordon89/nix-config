{ lib, useClaudeSidebar ? false }:
let
  chatSidebarCommand =
    if useClaudeSidebar
    then "claude-vscode.sidebar.open"
    else "workbench.action.chat.open";
  sidebarVisibleContext =
    if useClaudeSidebar
    then "sideBarVisible"
    else "auxiliaryBarVisible";
  toggleSidebarCommand =
    if useClaudeSidebar
    then "workbench.action.toggleSidebarVisibility"
    else "workbench.action.toggleAuxiliaryBar";
in
[
  {
    key = "ctrl+shift+x";
    command = "workbench.action.closeWindow";
  }
  {
    key = "cmd+t";
    command = "workbench.action.terminal.toggleTerminal";
  }
  {
    key = "cmd+e";
    command = "workbench.action.toggleSidebarVisibility";
  }
  {
    key = "cmd+shift+e";
    command = "workbench.action.toggleSidebarVisibility";
  }
  {
    key = "ctrl+shift+`";
    command = "workbench.action.toggleSidebarVisibility";
  }
  {
    key = "cmd+k cmd+e";
    command = "workbench.view.explorer";
  }
  {
    key = "cmd+k cmd+v";
    command = "workbench.view.scm";
  }
  {
    key = "cmd+k cmd+d";
    command = "workbench.view.debug";
  }
  {
    key = "cmd+k cmd+x";
    command = "workbench.extensions.action.showInstalledExtensions";
  }
  {
    key = "alt+cmd+b";
    command = chatSidebarCommand;
    when = "!${sidebarVisibleContext}";
  }
  {
    key = "alt+cmd+b";
    command = toggleSidebarCommand;
    when = sidebarVisibleContext;
  }
  # Fix for ansible extension and copilot
  {
    key = "tab";
    command = "-ansible.lightspeed.inlineSuggest.accept";
    when = "inlineSuggestionVisible && editorLangId == 'ansible'";
  }
  {
    key = "escape";
    command = "-ansible.lightspeed.inlineSuggest.hide";
    when = "inlineSuggestionVisible && editorLangId == 'ansible'";
  }
]
