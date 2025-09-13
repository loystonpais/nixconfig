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
    ./vfio
  ];

  services.pipewire.extraConfig.pipewire."80-combined" = {
    "context.modules" = [
      {
        name = "libpipewire-module-combine-stream";
        args = {
          "combine.mode" = "sink";
          "node.name" = "systemoutput+hdmioutput";
          "node.description" = "Both Laptop speakers and HDMI/Monitor speakers (systemoutput+hdmioutput)";
          "node.nick" = "systemoutput+hdmioutput";
          "combine.latency-compensate" = true;

          "combine.volume-sync" = true;
          "node.autoconnect" = true;

          "combine.props" = {
            "audio.position" = ["FL" "FR"];
          };
          "stream.rules" = [
            {
              matches = [
                {
                  # "media.class" = "Audio/Sink";
                  "node.name" = "alsa_output.pci-0000_06_00.6.analog-stereo";
                }
              ];
              actions = {
                create-stream = {
                  "combine.audio.position" = ["FL" "FR"];
                  "audio.position" = ["FL" "FR"];
                };
              };
            }

            {
              matches = [
                {
                  # "media.class" = "Audio/Sink";
                  "node.name" = "alsa_output.pci-0000_01_00.1.hdmi-stereo";
                }
              ];
              actions = {
                create-stream = {
                  "combine.audio.position" = ["FL" "FR"];
                  "audio.position" = ["FL" "FR"];
                };
              };
            }
          ];
        };
      }
    ];
  };

  services.pipewire.wireplumber.extraConfig."70-naming" = let
    rule = name: newNick: newDescription: {
      matches = [{"node.name" = name;}];
      actions = {
        update-props = {
          "node.nick" = newNick;
          "node.description" = newDescription;
        };
      };
    };
  in {
    "monitor.alsa.rules" = [
      (rule
        "alsa_output.pci-0000_06_00.6.analog-stereo"
        "systemoutput"
        "Laptop inbuilt speakers (systemoutput)")

      (rule "alsa_output.pci-0000_01_00.1.hdmi-stereo"
        "hdmioutput"
        "HDMI/Monitor Speakers (hdmioutput)")

      # input ones
      (rule
        "alsa_input.pci-0000_06_00.6.analog-stereo"
        "systeminput"
        "Laptop inbuilt microphone (systeminput)")
    ];
  };

  # Prevents ollama from redownloading...
  environment.variables.OLLAMA_NOPRUNE = lib.mkDefault "true";

  environment.systemPackages = [
    pkgs.brave
    pkgs.cachix
    pkgs.gcc
    pkgs.rclone

    inputs.self.packages.${system}.nautilus-scripts

    pkgs.devenv

    pkgs.nix-update

    pkgs.nautilus
  ];

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

  programs.kdeconnect.enable = true;

  networking = {
    networkmanager.unmanaged = [
      "interface-name:ve-*"
      # "interface-name:enp7s0f3u1u2"
    ];

    # interfaces.enp7s0f3u1u2.useDHCP = true;
  };

  services.displayManager.defaultSession = lib.mkForce "niri";

  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

  systemd.services.auractl-wallpaper = let
    #wallpaper = config.home-manager.users.${config.lunar.username}.programs.plasma.kscreenlocker.appearance.wallpaper
    #or config.stylix.image;
    wallpaper = config.lunar.wallpaper;
    scheme = config.stylix.base16Scheme;
    aura = "breathe";
    offset = 10;
  in {
    enable = true;
    path = [pkgs.asusctl pkgs.yq];
    script = ''
      palette=($(yq ".palette[]" -r '${scheme}' | cut -c 2-))

      # zone starts from 1
      for zone in {1..4}; do
        col=''${palette[(( $zone + ${builtins.toString offset} ))]}
        asusctl aura "${aura}" -c "$col" -z $zone;
        echo "Applied ${aura} $col to zone $zone";
      done;
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

  boot.tmp.cleanOnBoot = true;

  home-manager.users.${config.lunar.username}.imports = [
    {
      home.file.".local/share/PrismLauncher/instances/FSG/minecraft/fsg" = let
        pkg = inputs.self.packages.${system}.zig-seed-glitchless.override {
          zsgConfig = {
            enable_terrain_checker = true;
          };
        };
      in {
        source = "${pkg}/share/${pkg.pname}";
        recursive = true;
        force = true;
      };

      programs.obsidian.enable = true;
    }
  ];

  system.stateVersion = "23.11"; # Did you read the comment?
}
