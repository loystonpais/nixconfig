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
  ];

  programs.extra-container.enable = false;

  # services.ollama = {
  #   enable = true;
  #   acceleration = "cuda";
  # };

  lunar.modules.virtual-machine.nixvirt.enable = false;

  # Prevents ollama from redownloading...
  environment.variables.OLLAMA_NOPRUNE = lib.mkDefault "true";

  environment.systemPackages = [
    pkgs.brave
    pkgs.cachix
    pkgs.gcc
    pkgs.rclone
    pkgs.thunderbird
    inputs.self.packages.${system}.lumon-mdr
    inputs.self.packages.${system}.bind-to-interface
    inputs.self.packages.${system}.brisk

    inputs.self.packages.${system}.nautilus-scripts
  ];

  # lunar.modules.niri.enable = true;

  networking.dhcpcd.extraConfig = ''
    interface wlo1
    metric 99

    interface enp4s0
    metric 98
  '';

  networking.interfaces.wlo1.useDHCP = lib.mkDefault true;
  networking.interfaces.enp4s0.useDHCP = lib.mkDefault true;

  networking.firewall.enable = lib.mkForce false;

  hardware.i2c.enable = true;

  # services.displayManager.sddm = {
  #   package = lib.mkDefault pkgs.kdePackages.sddm;
  #   theme = "WhiteSur-dark";
  #   extraPackages = [pkgs.kdePackages.plasma-desktop pkgs.kdePackages.qtsvg];
  # };
  #

  lunar.modules.misc.supergfxd-lsof-overlay.enable = false;

  nixpkgs.overlays = [
    inputs.self.overlays.lunar
  ];

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

  networking = {
    networkmanager.unmanaged = [
      "interface-name:ve-*"
      # "interface-name:enp7s0f3u1u2"
    ];

    # interfaces.enp7s0f3u1u2.useDHCP = true;
  };

  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

  systemd.services.auractl-wallpaper = let
    wallpaper = config.home-manager.users.${config.lunar.username}.programs.plasma.kscreenlocker.appearance.wallpaper;
    aura = "breathe";
  in {
    enable = true;
    path = [pkgs.okolors pkgs.asusctl];
    script = ''
      COLS=($(okolors -k 4 -s h '${wallpaper}'))
      for x in {1..4}; do
        y=$((x - 1))
        COL="${"\${COLS[$y]}"}"
        asusctl aura "${aura}" -c "$COL" -z "$x" 2>&1  1>/dev/null
        echo "Applied ${aura} $COL to zone $x"
      done
    '';
    serviceConfig = {
      Type = "oneshot";
    };
    after = ["asusd.service"];
    wantedBy = ["multi-user.target"];
  };

  hardware.nvidia.prime = {
    offload.enable = true;
    offload.enableOffloadCmd = true;
    amdgpuBusId = "PCI:06:00:0";
    nvidiaBusId = "PCI:01:00:0";
  };

  system.stateVersion = "23.11"; # Did you read the comment?
}
