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
    pkgs.ddcutil
  ];

  # home-manager.users.${config.lunar.username}.imports = [
  #   {
  #     dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  #     dconf.settings."org/gnome/desktop/interface".gtk-theme = "Adwaita-dark";
  #     qt = {
  #       enable = true;
  #       platformTheme.name = "kde";
  #       style.name = "breeze";
  #     };
  #     home.file.".config/kdeglobals".source = "${pkgs.kdePackages.breeze}/share/color-schemes/BreezeDark.colors";
  #   }
  # ];

  services.flatpak.enable = true;

  lunar.modules.emacs.enable = true;

  users.users.${config.lunar.username} = {
    shell = lib.mkForce pkgs.xonsh;
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
    ];
  };

  boot.tmp.cleanOnBoot = true;

  lunar.modules.misc.libadwaita-without-adwaita-overlay.enable = false;

  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  system.stateVersion = "23.11"; # Did you read the comment?
}
