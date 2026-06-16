{ ... }:
{
  flake.modules.homeManager.packagesLanguages = { config, lib, pkgs, ... }:
    lib.mkIf (lib.elem "languages" config.meta.packages.groups) {
      home.packages =
        let
          all = {
            python = pkgs.python313.buildEnv.override {
              extraLibs = with pkgs.python313.pkgs; [
                pyyaml
                ruff
                ansible-core
                git-filter-repo
                llm
                llm-ollama
                llm-cmd
              ];
            };
            inherit (pkgs) typescript yarn bun cue go cargo;
          };
        in
        lib.attrValues (lib.removeAttrs all config.meta.packages.exclude);
    };
}
