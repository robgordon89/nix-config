{ config, pkgs, ... }:

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
    initExtra = # bash
      ''
        export PURE_GIT_PULL=0
        fpath+=("${pkgs.pure-prompt}/share/zsh/site-functions")

        if [ "$TERM" != dumb ]; then
          autoload -U promptinit && promptinit && prompt pure
        fi

        if command -v nix-your-shell > /dev/null; then
          nix-your-shell zsh | source /dev/stdin
        fi

        export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

        eval "$(direnv hook $SHELL)"

        . ${./config/options.zsh}
        . ${./config/completions.zsh}
        . ${./config/mappings.zsh}
        . ${./config/functions.zsh}
      '';

    shellAliases = {
      # Shorter
      g = "git";
      x = "exit";
      c = "clear";
      e = "nvim";
      v = "nvim";
      vi = "nvim";
      vim = "nvim";
      d = "docker";
      k = "kubectl";
      terraform = "tofu";
      tf = "tofu";
      kx = "kubectx";
      t = "tofu";

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
      exa = "exa --group-directories-first";
      ls-backend = "exa";
      ls = "exa";
      ll = "exa -l";
      lsa = "exa -a";
      lla = "exa -la";
      l = "exa";
    };

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
