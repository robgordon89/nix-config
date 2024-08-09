{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion = {
      enable = true;
      highlight = "fg=#ffcc00";
    };
    syntaxHighlighting.enable = true;
    initExtra = /*bash*/''
      ## ZSH HOOKS
      # precmd_hook
      hooks-define-hook precmd_hook
      function precmd-wrapper { hooks-run-hook precmd_hook }
      add-zsh-hook precmd precmd-wrapper

      # preexec_hook
      hooks-define-hook preexec_hook
      function preexec-wrapper { hooks-run-hook preexec_hook "$@" }
      add-zsh-hook preexec preexec-wrapper

      # chpwd_hook
      hooks-define-hook chpwd_hook
      function chpwd-wrapper { hooks-run-hook chpwd_hook }
      add-zsh-hook chpwd chpwd-wrapper

      . ${./config/options.zsh}
      . ${./config/completions.zsh}
      . ${./config/prompt.zsh}
      . ${./config/terminal_title.zsh}

      source ${pkgs.google-cloud-sdk}/share/bash-completion/completions/gcloud
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

      # Open current directory in Neovim
      "." = "nvim .";

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
      ll = "ls-backend";
      ls = "ll";
      lsa = "ll -a";
      lsal = "ll -al";
      l = "ls";

      update = "nix flake update --flake ~/nix-config";
      rebuild = "darwin-rebuild switch --flake ~/nix-config";
    };

    history = {
      size = 10000;
      save = 1000000;
      share = false;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    zplug = {
      enable = true;
      plugins = [
        { name = "hlissner/zsh-autopair"; }
        { name = "zsh-hooks/zsh-hooks"; }
        { name = "romkatv/gitstatus"; }
      ];
    };

  };
}
