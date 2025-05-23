{ inputs, ... }:
final: prev: {
  # example = prev.example.overrideAttrs (oldAttrs: let ... in {
  # ...
  # });
  #    flameshot = prev.flameshot.overrideAttrs {
  #      cmakeFlags = [
  #        (prev.lib.cmakeBool "USE_WAYLAND_GRIM" true)
  #        (prev.lib.cmakeBool "USE_WAYLAND_CLIPBOARD" true)
  #      ];
  #    };
}
