{
  lib,
  inputs,
  pkgs,
  config,
  system,
  ...
}: {
  imports = [
    ./lunar.nix
    ./extra-hardware.nix
    ./vfio
    ./backdrive-hibernation.nix
  ];

  environment.systemPackages = [
    inputs.self.packages.${system}.iso2god-rs
    pkgs.ddcutil
  ];

  ## Claude bs

  # # Create the bridge
  # networking.bridges.microbr.interfaces = ["microvm1"];

  # # Assign IP to bridge
  # networking.interfaces.microbr = {
  #   ipv4.addresses = [
  #     {
  #       address = "192.168.83.1";
  #       prefixLength = 24;
  #     }
  #   ];
  # };

  # # NAT
  # networking.nat = {
  #   enable = true;
  #   internalInterfaces = ["microbr"];
  #   externalInterface = "wlo1";
  # };

  # networking.firewall.trustedInterfaces = ["microbr"];

  ## claude bs end

  services.tailscale = {
    enable = true;
    # Enable tailscale at startup

    # If you would like to use a preauthorized key
    #authKeyFile = "/run/secrets/tailscale_key";
  };

  services.flatpak.enable = true;

  lunar.modules.emacs.enable = true;

  users.users.${config.lunar.username} = {
    extraGroups = ["i2c"];
  };

  nixpkgs.overlays = [
    inputs.self.overlays.lunar
  ];

  networking.firewall.enable = lib.mkForce false;

  # NOTE: move this to hardware-configuration.nix once the uid issue is fixed
  fileSystems."/mnt/windows" = {
    device = "/dev/disk/by-uuid/BA16A4A516A463DB";
    fsType = "ntfs-3g";
    options = ["nofail" "rw" "uid=${toString config.users.users.${config.lunar.username}.uid}"];
  };

  programs.kdeconnect.enable = true;

  lunar.modules.niri.enable = true;
  lunar.modules.dms.enable = true;

  networking.dhcpcd.enable = false;

  networking = {
    networkmanager.unmanaged = [
      "interface-name:ve-*"

      "interface-name:microbr"
      "interface-name:microvm*"
    ];
  };

  hardware.nvidia.prime = {
    offload.enable = true;
    offload.enableOffloadCmd = true;
  };

  lunar.modules.distrobox.enable = true;
  lunar.modules.podman.enable = true;

  boot.tmp.cleanOnBoot = true;

  lunar.modules.misc.libadwaita-without-adwaita-overlay.enable = false;

  # Set your profile
  lunar.profile.everything.enable = true;

  lunar.modules.plasma.mode = "mac";
  lunar.modules.plasma.enable = true;

  # Exclusion
  lunar.modules.samba.enable = false;
  lunar.modules.virtual-machine.nixvirt.enable = false;
  lunar.modules.waydroid.enable = false;
  lunar.modules.hyprland.enable = false;

  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  system.stateVersion = "23.11"; # Did you read the comment?
}
