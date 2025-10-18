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

  # Prevents ollama from redownloading...
  environment.variables.OLLAMA_NOPRUNE = lib.mkDefault "true";

  environment.systemPackages = [
    pkgs.cachix
    pkgs.gcc
    pkgs.rclone
    inputs.self.packages.${system}.nautilus-scripts
    pkgs.devenv
    pkgs.nix-update
    pkgs.nautilus
    inputs.self.packages.${system}.iso2god-rs
    pkgs.chromium
    # pkgs.ungoogled-chromium
  ];

  programs.starship = {
    enable = true;
  };

  programs.zsh.enable = lib.mkForce false;

  programs.xonsh = {
    enable = true;
    extraPackages = ps:
      with ps; [
        numpy
        xonsh.xontribs.xontrib-vox
        xonsh.xontribs.xonsh-direnv
        # coconut
        requests
      ];
  };

  users.users.${config.lunar.username} = {
    shell = lib.mkForce pkgs.xonsh;
  };

  programs.direnv = {
    enable = true;
    enableXonshIntegration = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableXonshIntegration = true;
  };

  lunar.modules.misc.supergfxd-lsof-overlay.enable = false;

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

  # boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

  # systemd.services.auractl-wallpaper = let
  #   scheme =
  #     if lib.isAttrs config.stylix.base16Scheme
  #     then builtins.toFile config.stylix.base16Scheme
  #     else config.stylix.base16Scheme;
  #   aura = "breathe";
  #   offset = 10;
  # in {
  #   enable = true;
  #   path = [pkgs.asusctl pkgs.yq];
  #   script = ''
  #     palette=($(yq ".palette[]" -r '${scheme}' | cut -c 2-))

  #     # zone starts from 1
  #     for zone in {1..4}; do
  #       col=''${palette[(( $zone + ${builtins.toString offset} ))]}
  #       asusctl aura "${aura}" -c "$col" -z $zone;
  #       echo "Applied ${aura} $col to zone $zone";
  #     done;
  #   '';
  #   serviceConfig = {
  #     Type = "oneshot";
  #   };
  #   after = ["asusd.service"];
  #   wantedBy = ["multi-user.target"];
  # };

  specialisation.plasma = {
    configuration = {
      config = {
        lunar.wallpaper = "${inputs.self}/assets/wallpapers/green-leaves.jpg";
        lunar.modules.niri.enable = lib.mkForce false;
        lunar.modules.waybar.enable = lib.mkForce false;

        lunar.modules.plasma.enable = lib.mkForce true;

        services.displayManager.defaultSession = lib.mkForce "plasma";

        systemd.services = {
          "delete-hm-backups-${config.lunar.username}" = {
            script = ''
              find /home/${config.lunar.username}/.config -name "*.nixbak" -delete
            '';
            before = ["home-manager-${config.lunar.username}.service"];
          };
        };
      };
    };
  };

  boot.tmp.cleanOnBoot = true;

  system.stateVersion = "23.11"; # Did you read the comment?
}
