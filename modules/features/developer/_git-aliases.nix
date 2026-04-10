{
  all = "!f() { ls -R -d */.git | xargs -P10 -I{} git -C {} $1; }; f";
  main = "checkout main";
  dev = "checkout develop";
  s = "status -sb";
  a = "add";
  c = "commit";
  p = "push";
  pb = "push origin HEAD";
  l = "log";
}
