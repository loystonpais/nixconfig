{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.lunar.modules.audio.enable {
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;

      jack.enable = lib.mkForce true;

      wireplumber.enable = lib.mkDefault true;
      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };

    environment.systemPackages = with pkgs; [
      helvum
      sonusmix
      pwvucontrol
    ];

    users.extraUsers.${config.lunar.username}.extraGroups = ["jackaudio"];
  };
}
