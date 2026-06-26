{ ... }:
{
  flake.modules.homeManager.finderSidebar =
    { pkgs, lib, ... }:
    {
      home.activation.finderSidebarFavourites =
        lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          dev="$HOME/dev"
          run mkdir -p "$dev"
          if ! ${pkgs.mysides}/bin/mysides list | grep -q "^dev "; then
            run ${pkgs.mysides}/bin/mysides add dev "file://$dev"
          fi
        '';
    };
}
