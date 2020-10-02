{ }:
let
  sources = import sourcesnix { sourcesFile = ./sources.json; };
  sourcesnix = builtins.fetchurl {
    url = https://raw.githubusercontent.com/nmattia/niv/v0.2.18/nix/sources.nix;
    sha256 = "0vsjk1dj88kb40inlhb9xgfhm5dfhb6g3vyca62glk056sn4504l";
  };
in
import sources.nixpkgs {
  overlays = [
    (_: pkgs: { inherit sources; })
  ];
  config = {};
}
