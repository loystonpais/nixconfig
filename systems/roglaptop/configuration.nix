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

  fileSystems."/mnt/seagate" = {
    device = "/dev/disk/by-uuid/0033d291-3466-4b6d-be98-35d615af7571";
    fsType = "xfs";
    options = ["nofail"];
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

  systemd.services = {
    "delete-hm-backups-${config.lunar.username}" = {
      script = ''
        find /home/${config.lunar.username}/.config -name "*.nixbak" -delete
        rm /home/${config.lunar.username}/.gtkrc-2.0
      '';
      before = ["home-manager-${config.lunar.username}.service"];
    };
  };

  boot.tmp.cleanOnBoot = true;

  system.stateVersion = "23.11"; # Did you read the comment?
}
