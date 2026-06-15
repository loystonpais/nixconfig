{den, ...}: {
  lunar.wayland = {
    provides.tools = {
      nixos = {pkgs, ...}: {
        environment.systemPackages = with pkgs; [
          grim
          slurp
          swappy
          ksnip
          satty

          wl-clipboard
          wl-gammactl
          wl-color-picker
        ];
      };
    };
  };
}
