{ ... }:
{
  flake.modules.darwin.cmux = {
    homebrew.casks = [
      {
        name = "manaflow-ai/cmux/cmux";
        greedy = true;
      }
    ];
  };
}
