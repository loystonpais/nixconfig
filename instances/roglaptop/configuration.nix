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

  services.ollama = {
    enable = true;
    acceleration = "cuda";
  };

  lunar.modules.virtual-machine.nixvirt.enable = false;

  # Prevents ollama from redownloading...
  environment.variables.OLLAMA_NOPRUNE = lib.mkDefault "true";

  environment.systemPackages = [
    pkgs.ungoogled-chromium
    pkgs.cachix
    pkgs.gcc
    pkgs.rclone
    inputs.self.packages.${system}.lumon-mdr
  ];

  # services.displayManager.sddm = {
  #   package = lib.mkDefault pkgs.kdePackages.sddm;
  #   theme = "WhiteSur-dark";
  #   extraPackages = [pkgs.kdePackages.plasma-desktop pkgs.kdePackages.qtsvg];
  # };
  #

  # NOTE: move this to hardware-configuration.nix once the uid issue is fixed
  fileSystems."/mnt/windows" = {
    device = "/dev/disk/by-uuid/BA16A4A516A463DB";
    fsType = "ntfs-3g";
    options = ["nofail" "rw" "uid=${config.users.users.${config.lunar.username}.uid}"];
  };

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
