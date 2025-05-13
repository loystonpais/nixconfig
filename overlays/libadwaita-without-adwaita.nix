# source: https://github.com/caffeine01/dotfiles/blob/2ad8ba8a467d827f0a9b2ff7c370a9367dcf9d1d/modules/libadwaita-without-adwaita.nix
{
  lib,
  config,
  inputs,
  system,
  pkgs,
  ...
}: {
  config = lib.mkIf config.lunar.overlays.libadwaita-without-adwaita-patch.enable {
    nixpkgs.overlays = let
      aurRepo = pkgs.fetchgit {
        url = "https://aur.archlinux.org/libadwaita-without-adwaita-git.git";
        rev = "312880664a0b37402a93d381c9465967d142284a";
        hash = "sha256-Z8htdlLBz9vSiv5qKpCLPoFqk14VTanaLpn+mBITq3o=";
      };
      themingPatch = aurRepo + "/theming_patch.diff";
    in [
      (final: prev: {
        libadwaita-without-adwaita = prev.libadwaita.overrideAttrs (old: {
          doCheck = false;
          patches =
            (old.patches or [])
            ++ [
              themingPatch
            ];
          mesonFlags =
            (old.mesonFlags or [])
            ++ [
              "--buildtype=release"
              "-Dexamples=false"
            ];
        });
      })
    ];
    system.replaceDependencies.replacements = with pkgs; [
      {
        oldDependency = libadwaita.out;
        newDependency = libadwaita-without-adwaita.out;
      }
    ];
  };
}
