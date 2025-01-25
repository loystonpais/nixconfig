{
  lib,
  config,
  ...
}:
with lib; {
  config = mkIf config.lunar.profile.everything.enable {
    lunar.modules = {
      desktop-environments.enableAll = mkDefault true;
      distrobox.enable = mkDefault true;
      gamedev.enable = mkDefault true;
      gaming.enable = mkDefault true;
      minecraft.enable = mkDefault true;
      multimedia.enable = mkDefault true;
      piracy.enable = mkDefault true;
      program-collection.enable = mkDefault true;
      samba.enable = mkDefault true;
      virtual-machine.enable = mkDefault true;
      waydroid.enable = mkDefault true;
      browsers.enable = mkDefault true;
      android.enable = mkDefault true;
      ssh.enable = mkDefault true;
      secrets.enable = mkDefault true;
      audio.enable = mkDefault true;
      graphics.enable = mkDefault true;
      hardware.enable = mkDefault true;

      home-manager = {
        enable = mkDefault true;
        enableAllModules = mkDefault true;
      };
    };
  };
}
