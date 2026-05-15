{
  all = "!f() { ls -d */.git | sed 's,/.git$,,' | xargs -P10 -I{} git -C {} \"$@\"; }; f";
  pull-default = "!f() { ls -d */.git | sed 's,/.git$,,' | xargs -P10 -I{} sh -c 'b=$(git -C \"$1\" symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | sed s,^origin/,,); [ -n \"$b\" ] && git -C \"$1\" pull --ff-only origin \"$b\"' _ {}; }; f";
  main = "checkout main";
  dev = "checkout develop";
  s = "status -sb";
  a = "add";
  c = "commit";
  p = "push";
  pb = "push origin HEAD";
  l = "log";
}
