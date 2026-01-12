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
  ];

  environment.systemPackages = [
    inputs.self.packages.${system}.iso2god-rs
  ];

  services.flatpak.enable = true;

  lunar.modules.emacs.enable = true;

  users.users.${config.lunar.username} = {
    shell = lib.mkForce pkgs.xonsh;
  };

  nixpkgs.overlays = [
    inputs.self.overlays.lunar
  ];

  networking.firewall.enable = lib.mkForce false;

  # NOTE: move this to hardware-configuration.nix once the uid issue is fixed
  fileSystems."/mnt/windows" = {
    device = "/dev/disk/by-uuid/BA16A4A516A463DB";
    fsType = "ntfs-3g";
    options = ["nofail" "rw" "uid=${builtins.toString config.users.users.${config.lunar.username}.uid}"];
  };

  programs.kdeconnect.enable = true;

  networking = {
    networkmanager.unmanaged = [
      "interface-name:ve-*"
      # "interface-name:enp7s0f3u1u2"
    ];

    # interfaces.enp7s0f3u1u2.useDHCP = true;
  };

  lunar.wallpaper = "${inputs.self}/assets/wallpapers/green-leaves.jpg";
  lunar.modules.plasma.enable = lib.mkForce true;

  services.displayManager.defaultSession = lib.mkForce "plasma";

  boot.tmp.cleanOnBoot = true;

  lunar.modules.misc.libadwaita-without-adwaita-overlay.enable = false;

  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  system.stateVersion = "23.11"; # Did you read the comment?
}
