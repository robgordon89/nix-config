{ inputs, ... }:
final: _prev: {
  wrangler = inputs.wrangler.packages.${final.stdenv.hostPlatform.system}.wrangler;
}
