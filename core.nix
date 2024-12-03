# this is named core for the lack of any names
{ config, pkgs, lib, ... }:

{
  imports = [
    ./modules
    ./profiles
    ./required
    ./overlays
    ./users
    ./vars.nix
    ./defvars.nix
  ];

  networking.hostName = config.vars.hostName;
  networking.networkmanager.enable = true;

  # Explicitly set firewall to true (pretty sure its enabled by default)
  networking.firewall.enable = true;

  # Enable opengl/graphics
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # X11 not needed
  services.xserver.enable = false;

  services.printing.enable = true;

  hardware.pulseaudio.enable = false;


  hardware.bluetooth.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Set your time zone.
  time.timeZone = config.vars.timeZone;

  # Select internationalisation properties.
  i18n.defaultLocale = config.vars.locale;

  i18n.extraLocaleSettings = {
    LC_ADDRESS = config.vars.locale;
    LC_IDENTIFICATION = config.vars.locale;
    LC_MEASUREMENT = config.vars.locale;
    LC_MONETARY = config.vars.locale;
    LC_NAME = config.vars.locale;
    LC_NUMERIC = config.vars.locale;
    LC_PAPER = config.vars.locale;
    LC_TELEPHONE = config.vars.locale;
    LC_TIME = config.vars.locale;
  };

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-esr;
    preferences = {
      "widget.use-xdg-desktop-portal.file-picker" = 1;
    };
  };

  programs.nix-ld.enable = true;


  environment.systemPackages = with pkgs; [
    vim
    git
    fastfetch
    home-manager
    nh
    pciutils
    ripgrep
    file
    busybox
    python3
    android-tools # its not that huge and very useful
    libnotify
    unar
  ];

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}