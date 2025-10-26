{
  lib,
  config,
  ...
}:
with lib; {
  config = mkIf config.lunar.profile.everything.enable {
    lunar.modules = {
      distrobox.enable = mkDefault true;
      gamedev.enable = mkDefault true;
      gaming.enable = mkDefault true;
      minecraft.enable = mkDefault true;
      multimedia.enable = mkDefault true;
      piracy.enable = mkDefault true;
      misc.enableAll = mkDefault true;
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
      nixvim.enable = mkDefault true;
      plasma.enable = mkDefault true;
      bluetooth.enable = mkDefault true;
      fonts.enable = mkDefault true;
      git.enable = mkDefault true;
      hyprland.enable = mkDefault true;
      zsh.enable = mkDefault true;
      program-collection.enable = mkDefault true;
      zed.enable = mkDefault true;
      xonsh.enable = mkDefault true;
    };

    lunar.specialisations.enable = mkDefault false;
  };
}
