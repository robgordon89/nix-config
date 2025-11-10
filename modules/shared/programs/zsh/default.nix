{ config, pkgs, hostConfig ? { }, ... }:
let
  # Conditionally set up editor-specific configuration
  editorPath =
    if hostConfig.useCursor or false then
      "/Applications/Cursor.app/Contents/Resources/app/bin"
    else if hostConfig.useVscode or false then
      "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
    else "";

  editorAlias =
    if hostConfig.useCursor or false then
      { code = "cursor"; }
    else if hostConfig.useVscode or false then
      { code = "code"; }
    else { };
in
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion = {
      enable = true;
      highlight = "fg=#ffcc00";
      strategy = [ "history" ];
    };
    syntaxHighlighting.enable = true;
    initContent = ''
      export PURE_GIT_PULL=0
      fpath+=("${pkgs.pure-prompt}/share/zsh/site-functions")

      if [ "$TERM" != dumb ]; then
        autoload -U promptinit && promptinit && prompt pure
      fi

      # Nix-your-shell integration
      ${pkgs.nix-your-shell}/bin/nix-your-shell zsh | source /dev/stdin

      ${if editorPath != "" then ''export PATH="$PATH:${editorPath}"'' else ""}

      . ${./config/options.zsh}
      . ${./config/completions.zsh}
      . ${./config/mappings.zsh}
      . ${./config/functions.zsh}
    '';

    shellAliases = {
      # Listing with eza
      ls = "${pkgs.eza}/bin/eza --group-directories-first" + (if pkgs ? eza then "" else "ls");
      ll = "${pkgs.eza}/bin/eza --group-directories-first -la" + (if pkgs ? eza then "" else "ll");
      la = "${pkgs.eza}/bin/eza --group-directories-first -a" + (if pkgs ? eza then "" else "la");
      lt = "${pkgs.eza}/bin/eza --group-directories-first --tree" + (if pkgs ? eza then "" else "lt");

      # Shorter
      g = "git";
      x = "exit";
      c = "clear";
      e = "nvim";
      v = "nvim";
      vi = "nvim";
      vim = "nvim";

      # Docker shortcuts
      d = "docker";
      dc = "docker-compose";
      dps = "docker ps";
      dimg = "docker images";

      # Kubernetes shortcuts
      k = "kubectl";
      kgp = "kubectl get pods";
      kgs = "kubectl get services";
      kgd = "kubectl get deployments";
      kl = "kubectl logs";
      kex = "kubectl exec -it";
      kctx = "kubectx";
      kx = "kubectx";
      kns = "kubens";

      terraform = "tofu";


      # Utility aliases
      cat = "${pkgs.bat}/bin/bat --style=auto" + (if pkgs ? bat then "" else "cat");
      grep = "${pkgs.ripgrep}/bin/rg" + (if pkgs ? ripgrep then "" else "grep");
      find = "${pkgs.fd}/bin/fd" + (if pkgs ? fd then "" else "find");
      ps = "${pkgs.procs}/bin/procs" + (if pkgs ? procs then "" else "ps");

      # Add verbosity to common commands
      rm = "rm -v";
      cp = "cp -vi";
      mv = "mv -vi";
      ln = "ln -iv";
      mkdir = "mkdir -v";
      rand = "openssl rand -base64 32";

      # git stuff
      nah = "git reset --hard && git clean -df";
      push = "git push origin `git rev-parse --abbrev-ref HEAD`";
      pull = "git pull origin `git rev-parse --abbrev-ref HEAD`";
      add = "git add $@";
      commit = "git commit -m '$@'";
      amend = "git add -A && git commit --amend --no-edit";
      gitcleanbranches = "git branch --merged | grep -v \* | xargs git branch -D";

      ssh = "TERM=xterm ssh";
    } // editorAlias;

    history = {
      size = 10000;
      save = 1000000;
      share = true;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    zplug = {
      enable = true;
      plugins = [
        { name = "hlissner/zsh-autopair"; }
        { name = "zsh-hooks/zsh-hooks"; }
      ];
    };

    plugins = [ ];

  };
}
