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

  lunar.specialisations = {
    enable = true;
    productive.enable = true;
  };

  # Mainly for wither
  lunar.modules.virtual-machine.cgroupDevicesById = [
    "usb-Razer_Razer_DeathAdder_Essential-event-mouse"
    "usb-Usb_KeyBoard_Usb_KeyBoard-event-kbd"
  ];
  lunar.modules.virtual-machine.nixvirt.enable = false;

  # Prevents ollama from redownloading...
  environment.variables.OLLAMA_NOPRUNE = "true";

  lunar.modules.desktop-environments.hyprland.enable = true;

  environment.systemPackages = [
    inputs.idk-shell-command.packages.${system}.default
    pkgs.ungoogled-chromium
    pkgs.cachix
    pkgs.gcc
    pkgs.nix-init
    pkgs.devenv
    pkgs.comma
    # pkgs.nixos-generators # package version is old

    inputs.winapps.packages."${system}".winapps
    inputs.winapps.packages."${system}".winapps-launcher
    pkgs.rclone

    pkgs.ente-auth

    #(pkgs.callPackage ./spotify-adblock.nix {})
    pkgs.spotify

    # pkgs.whitesur-kde
    #
    (pkgs.runCommand "sddm-background-image" {} ''
      CONFIG_PATH=$out/share/sddm/breeze/

      mkdir -p $CONFIG_PATH
      cat > "$CONFIG_PATH"/theme.conf.user <<EOF
      [General]
      background=${pkgs.whitesur-kde}/share/wallpapers/WhiteSur-dark/contents/images/3840x2160.jpg
      EOF
    '')
  ];

  # services.displayManager.sddm = {
  #   package = lib.mkDefault pkgs.kdePackages.sddm;
  #   theme = "WhiteSur-dark";
  #   extraPackages = [pkgs.kdePackages.plasma-desktop pkgs.kdePackages.qtsvg];
  # };
  #

  # NOTE: move this to hardware-configuration.nix once the uid issue is fixed
  boot.supportedFilesystems = ["ntfs"];
  fileSystems."/mnt/windows" = {
    device = "/dev/disk/by-uuid/BA16A4A516A463DB";
    fsType = "ntfs-3g";
    options = ["nofail" "rw" "uid=1001"];
  };

  lunar.modules.android.adbDevices = {
    vili = {
      ip = "192.168.43.2";
      port = 5555;
    };
  };

  # specialisation.integrated = {
  #   configuration = {
  #     services.supergfxd.settings = {
  #       mode = "Integrated";
  #       # vfio_enable = true;
  #       # vfio_save = true;
  #       # gfx_vfio_enable = true;
  #       # always_reboot = false;
  #       # no_logind = false;
  #       # logout_timeout_s = 180;
  #       # hotplug_type = "None";
  #     };
  #   };
  # };
  #

  hardware.nvidia.prime = {
    offload.enable = true;
    offload.enableOffloadCmd = true;
    amdgpuBusId = "PCI:06:00:0";
    nvidiaBusId = "PCI:01:00:0";
  };

  system.stateVersion = "23.11"; # Did you read the comment?
}
