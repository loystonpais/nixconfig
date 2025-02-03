{ pkgs ? import <nixpkgs> { } }:
pkgs.asusctl.overrideAttrs (f: p: {
  version = p.version + "-temp-g513rc-zonefix";
  src = pkgs.fetchFromGitHub {
    owner = "loystonpais";
    repo = "asusctl";
    rev = "44f7f91fc4b6cf665df9063c850a114fca7f0aef";
    hash = "sha256-aPVgbv5NvcmsXF6abGrEbdTMYtyYn1Yf422YV1U9+s0=";
  };
})
