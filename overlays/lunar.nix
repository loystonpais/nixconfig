{pkgs, ...}: let
in {
  config = {
    nixpkgs.overlays = [
      (final: prev: {
        lunar = {
          writeKioServiceMenu = name: text:
            pkgs.writeTextFile {
              inherit name;
              inherit text;
              destination = "/share/kio/servicemenus/${name}.desktop";
              executable = true;
            };
        };
      })
    ];
  };
}
