{ ... }:
{
  flake.modules.darwin.tablepro = {
    homebrew.casks = [
      {
        name = "tablepro";
        greedy = true;
      }
    ];
  };
}
