{
  "editor.fontSize" = 14;
  "editor.lineHeight" = 28;
  "editor.folding" = false;
  "editor.lineNumbers" = "on";
  "editor.minimap.enabled" = false;
  "editor.renderWhitespace" = "all";
  "editor.detectIndentation" = false;
  "editor.snippetSuggestions" = "top";
  "editor.guides.indentation" = false;
  "editor.stickyScroll.enabled" = false;
  "editor.inlineSuggest.enabled" = true;
  "editor.multiCursorModifier" = "ctrlCmd";
  "editor.emptySelectionClipboard" = false;
  "editor.minimap.renderCharacters" = false;
  "editor.copyWithSyntaxHighlighting" = false;
  "editor.fontFamily" = "Geist Mono, monospace";
  "editor.wordSeparators" = "`~!@#$%^&*.()-=+[{]}\\|;:'\",<>/?";

  "editor.hover.enabled" = true;
  "editor.matchBrackets" = "never";
  "editor.colorDecorators" = false;
  "editor.lightbulb.enabled" = "off";
  "editor.selectionHighlight" = false;
  "editor.overviewRulerBorder" = false;
  "editor.renderLineHighlight" = "none";
  "editor.occurrencesHighlight" = "off";
  "editor.accessibilitySupport" = "off";
  "editor.renderControlCharacters" = false;
  "editor.hideCursorInOverviewRuler" = true;
  "editor.gotoLocation.multipleReferences" = "goto";
  "editor.gotoLocation.multipleDefinitions" = "goto";
  "editor.gotoLocation.multipleDeclarations" = "goto";
  "editor.gotoLocation.multipleImplementations" = "goto";
  "editor.gotoLocation.multipleTypeDefinitions" = "goto";

  "window.commandCenter" = false;
  "window.nativeFullScreen" = false;
  "window.titleBarStyle" = "native";
  "window.autoDetectColorScheme" = true;
  "window.newWindowDimensions" = "inherit";

  "files.trimFinalNewlines" = true;
  "files.insertFinalNewline" = true;
  "files.trimTrailingWhitespace" = false;

  "workbench.iconTheme" = null;
  "workbench.tips.enabled" = false;
  "workbench.startupEditor" = "none";
  "workbench.editor.showIcons" = false;
  "workbench.sideBar.location" = "left";
  "workbench.statusBar.visible" = false;
  "workbench.editor.showTabs" = "multiple";
  "workbench.editor.enablePreview" = false;
  "workbench.layoutControl.enabled" = false;
  "workbench.activityBar.location" = "hidden";
  "workbench.editor.enablePreviewFromQuickOpen" = false;

  "workbench.colorTheme" = "Default High Contrast";
  "workbench.preferredDarkColorTheme" = "Default High Contrast";
  "workbench.preferredLightColorTheme" = "Default High Contrast Light";
  "workbench.colorCustomizations" = {
    "[Default High Contrast]" = {
      "sideBarTitle.foreground" = "#000000";
      "panelTitle.activeBorder" = "#000000";
      "panelTitle.border" = "#353839";
      "panelStickyScroll.border" = "#000000";
      # "list.focusOutline" = "#ff0000";
      "contrastActiveBorder" = "#353839";
      # "contrastBorder" = "#cccccc";
      # "focusBorder" = "#000000";
    };
  };


  "terminal.integrated.fontSize" = 14;
  "terminal.explorerKind" = "external";
  "terminal.integrated.cursorBlinking" = true;
  "terminal.integrated.fontFamily" = "Geist Mono, monospace";
  "terminal.integrated.enableMultiLinePasteWarning" = "never";

  "breadcrumbs.enabled" = false;
  "scm.diffDecorations" = "all";
  "git.decorations.enabled" = true;
  "problems.decorations.enabled" = false;
  "diffEditor.ignoreTrimWhitespace" = false;

  "search.useIgnoreFiles" = false;
  "search.exclude" = {
    "**/vendor/{[^l],?[^ai]}*" = true;
    "**/public/{[^i],?[^n]}*" = true;
    "**/node_modules" = true;
    "**/dist" = true;
    "**/_ide_helper.php" = true;
    "**/composer.lock" = true;
    "**/package-lock.json" = true;
    "storage" = true;
    ".phpunit.result.cache" = true;
  };

  "prettier.singleQuote" = false;
  "prettier.requireConfig" = true;
  "php-cs-fixer.lastDownload" = 1715169674762;
  # "php-cs-fixer.executablePath" = "${extensionPath}/php-cs-fixer.phar";

  "files.associations" = {
    "*.yml" = "yaml";
    "*.yaml" = "yaml";
    "*.yml.j2" = "ansible";
    "helm/**/*.yaml" = "helm";
    "**/helm/**/*.yaml" = "helm";
    "**/*helm/**/*.yaml" = "helm";
    "**/helm*/**/*.yaml" = "helm";
    "**/roles/**/*.yml" = "ansible";
    "**/templates/**/*.yaml" = "helm";
    "**/playbooks/**/*.yml" = "ansible";
  };

  "[nix]"."editor.tabSize" = 2;
  "[nix]"."editor.insertSpaces" = true;
  "[nix]"."editor.formatOnSave" = true;

  "[helm]"."editor.tabSize" = 2;
  "[helm]"."editor.insertSpaces" = true;
  "[helm]"."editor.formatOnSave" = true;

  "[yaml]"."editor.tabSize" = 2;
  "[yaml]"."editor.insertSpaces" = true;
  "[yaml]"."editor.formatOnSave" = true;
  "[yaml]"."editor.defaultFormatter" = "redhat.vscode-yaml";

  "[json]"."editor.defaultFormatter" = "esbenp.prettier-vscode";

  "[markdown]"."editor.defaultFormatter" = "esbenp.prettier-vscode";

  "[php]"."editor.defaultFormatter" = "junstyle.php-cs-fixer";

  "[javascript]"."editor.tabSize" = 4;
  "[javascript]"."editor.insertSpaces" = true;
  "[javascript]"."editor.formatOnSave" = true;
  "[javascript]"."editor.defaultFormatter" = "esbenp.prettier-vscode";

  "[python]"."editor.formatOnSave" = true;
  "[python]"."editor.defaultFormatter" = "ms-python.black-formatter";

  "[terraform]"."editor.formatOnSave" = true;
  "[terraform]"."editor.defaultFormatter" = "hashicorp.terraform";

  "[typescript]"."editor.tabSize" = 4;
  "[typescript]"."editor.insertSpaces" = true;
  "[typescript]"."editor.formatOnSave" = true;
  "[typescript]"."editor.defaultFormatter" = "esbenp.prettier-vscode";

  "[html]"."editor.defaultFormatter" = "vscode.html-language-features";

  "redhat.telemetry.enabled" = false;

  "yaml.customTags" = [
    "!encrypted/pkcs1-oaep scalar"
    "!vault scalar"
  ];

  "terraform.languageServer.enable" = true;
  "terraform.languageServer.path" = "";

  "python.experiments.enabled" = false;

  "github.copilot.editor.enableAutoCompletions" = true;

  "vs-kubernetes.vs-kubernetes.crd-code-completion" = "enabled";

  "custom-ui-style.electron" = {
    "frame" = false;
    "roundedCorners" = false;
  };
}
