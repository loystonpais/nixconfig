{ config, lib, ... }: {
  config = lib.mkIf config.luner.modules.graphics.enable {
    # Configure keymap in X11
    services.xserver = {
      enable = false;
      xkb.layout = "us";
      xkb.variant = "";
    };

    # Enable opengl/graphics
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
