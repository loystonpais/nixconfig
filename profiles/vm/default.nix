{
  lib,
  config,
  pkgs,
  ...
}:
with lib; {
  config = mkIf config.lunar.profile.vm.enable {
    lunar.modules.plasma.enable = mkDefault true;
    lunar.modules.multimedia.enable = mkDefault true;

    lunar.modules.ssh.enable = mkDefault true;

    lunar.modules.secrets.enable = mkDefault true;

    lunar.modules.audio.enable = mkDefault true;
    lunar.modules.hardware.enable = mkDefault true;
    lunar.modules.graphics.enable = mkDefault true;

    environment.systemPackages = with pkgs; [
      gparted
    ];
  };
}
