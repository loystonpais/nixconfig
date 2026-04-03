{den, ...}: {
  lunar.audio = {
    nixos = {pkgs, ...}: {
      services.pulseaudio.enable = false;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
        wireplumber.enable = true;
      };

      environment.systemPackages = with pkgs; [crosspipe pwvucontrol];
    };
  };
}
