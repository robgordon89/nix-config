{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

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
      path = "${config.xdg.dataHome}/zsh/history";
    };

    zplug = {
      enable = true;
      plugins = [
        { name = "hlissner/zsh-autopair"; }
        { name = "romkatv/gitstatus"; }
      ];
    };

  };
}
