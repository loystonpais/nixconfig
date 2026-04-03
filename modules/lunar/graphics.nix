{den, ...}: {
  lunar.graphics = {
    nixos = {...}: {
      services.xserver.enable = false;
      services.xserver.xkb = {
        layout = "us";
        variant = "";
      };
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };
    };
  };
}
