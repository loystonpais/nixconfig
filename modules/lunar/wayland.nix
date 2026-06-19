{den, ...}: {
  lunar.wayland = {
    provides.tools = {
      nixos = {pkgs, ...}: {
        environment.systemPackages = with pkgs; [
          grim
          slurp
          swappy
          satty

          wl-clipboard
          wl-gammactl
          wl-color-picker

          imagemagick
        ];
      };
    };
  };
}
