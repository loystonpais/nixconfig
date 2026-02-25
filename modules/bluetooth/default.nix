{
  config,
  lib,
  ...
}: {
  options.lunar.modules.bluetooth = {
    enable = lib.mkEnableOption "bluetooth";
    home.enable = lib.mkEnableOption "bluetooth home-manager";
  };

  config = lib.mkIf config.lunar.modules.bluetooth.enable (lib.mkMerge [
    {
      lunar.modules.bluetooth.home.enable = lib.mkDefault true;
      home-manager.users.${config.lunar.username}.imports = [
        ./home.nix
      ];
    }

    {
      hardware.bluetooth.enable = true;
    }

    {
      # Fixes random bluetooth headset disconnection
      hardware.bluetooth.settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
        };
      };
    }
  ]);
}
