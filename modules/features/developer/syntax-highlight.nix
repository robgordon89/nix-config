{ ... }:
{
  flake.modules.darwin.syntaxHighlight = {
    homebrew.casks = [ { name = "syntax-highlight"; greedy = true; } ];
  };
}
