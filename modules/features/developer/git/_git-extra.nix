{
  core = {
    editor = "nvim";
  };
  init = {
    defaultBranch = "main";
  };
  pull = {
    default = "current";
    rebase = "false";
  };
  push = {
    default = "current";
  };
  commit = {
    gpgSign = true;
  };
  tag = {
    gpgSign = true;
  };
  gpg = {
    format = "ssh";
  };
  diff = {
    "ansible-vault" = {
      textconv = "ansible-vault view";
    };
  };
}
