{
  all = "!f() { ls -d */.git | sed 's,/.git$,,' | xargs -P10 -I{} git -C {} \"$@\"; }; f";
  pull-default = "!f() { ls -d */.git | sed 's,/.git$,,' | xargs -P10 -I{} sh -c 'b=$(git -C \"$1\" symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | sed s,^origin/,,); [ -n \"$b\" ] && git -C \"$1\" pull --ff-only origin \"$b\"' _ {}; }; f";
  checkout-pull = "!f() { git checkout \"$1\" || return; git fetch -q origin \"$1\" || return; n=$(git rev-list --count HEAD..origin/\"$1\"); [ \"$n\" -eq 0 ] && return; printf 'Pull %s new commit(s) into %s? [y/N] ' \"$n\" \"$1\"; read -r a; case $a in [yY]*) git pull --ff-only origin \"$1\";; esac; }; f";
  main = "!git checkout-pull main";
  dev = "!git checkout-pull develop";
  default = "!f() { git remote set-head origin --auto >/dev/null && b=$(git symbolic-ref --short refs/remotes/origin/HEAD | sed 's,^origin/,,') && git checkout-pull \"$b\"; }; f";
  s = "status -sb";
  a = "add";
  c = "commit";
  p = "push";
  pb = "push origin HEAD";
  l = "log";
}
