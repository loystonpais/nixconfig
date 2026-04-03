{
  config,
  lib,
  ...
}: {
  options.lunar.modules.cuda = {
    enable = lib.mkEnableOption "cuda";
    home.enable = lib.mkEnableOption "cuda home-manager";
  };

  config = lib.mkIf config.lunar.modules.cuda.enable (lib.mkMerge [
    {
      lunar.modules.cuda.home.enable = lib.mkDefault true;
      home-manager.users.${config.lunar.username}.imports = [
        ./home.nix
      ];
    }

    {
      nix.settings = {
        substituters = [
          "https://cache.nixos-cuda.org?priority=20"
        ];
        trusted-public-keys = [
          "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
        ];
      };
    }

    # Flox now provides binary cache for cuda stuff
    # https://flox.dev/blog/the-flox-catalog-now-contains-nvidia-cuda/

    /*
    NixOS users can pull CUDA drivers and user-space packages from Flox’s binary cache by adding it as an extra-substituter, and can then maximize the chances of a cache hit by pinning nixpkgs to one of github:flox/nixpkgs/{unstable,staging,stable,lts} (recommended) or github:NixOS/nixpkgs/nixos-unstable.
    */
    {
      nix.settings = {
        substituters = [
          "https://cache.flox.dev?priority=15"
        ];
        trusted-public-keys = [
          "flox-cache-public-1:7F4OyH7ZCnFhcze3fJdfyXYLQw/aV7GEed86nQ7IsOs="
        ];
      };
    }
  ]);
}
