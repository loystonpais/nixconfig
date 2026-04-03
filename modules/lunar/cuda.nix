{den, ...}: {
  lunar.cuda = {
    nixos = {...}: {
      nix.settings = {
        substituters = ["https://cache.nixos-cuda.org" "https://cache.flox.dev"];
        trusted-public-keys = [
          "cache.nixos-cuda.org:nFezAYMPhmmzYQ9TJ5dHqM1L28J0SPT3RAHlGH2wd6M="
          "cache.flox.dev:6Xu+CmU56tJCzVa2YpS2IZ+Ib73z6eXALm94RdU4pQE="
        ];
      };

      nix.registry.nixpkgs-flox-unstable.to = {
        type = "github";
        owner = "flox";
        repo = "nixpkgs";
        ref = "unstable";
      };
    };
  };
}
