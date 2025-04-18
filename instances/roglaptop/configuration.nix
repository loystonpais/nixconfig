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

  programs.extra-container.enable = true;

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
  lunar.modules.virtual-machine.nixvirt.enable = true;

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
  ];

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

  #home-manager.backupFileExtension = "nixbak";

  # with builtins; throw (baseNameOf (toString ./.))

  # containers.wither = {
  #   autoStart = false;

  #   bindMounts = {
  #     "/dev/input/by-id/usb-Usb_KeyBoard_Usb_KeyBoard-event-kbd" = {
  #       hostPath = "/dev/input/by-id/usb-Usb_KeyBoard_Usb_KeyBoard-event-kbd";
  #       isReadOnly = false;
  #     };

  #     "/run/user/1001/wayland-0" = {
  #       # It is 1001 for me
  #       hostPath = "/run/user/1001/wayland-0";
  #       isReadOnly = false;
  #     };

  #     "/tmp/.X11-unix" = {
  #       hostPath = "/tmp/.X11-unix";
  #       isReadOnly = false;
  #     };

  #     "/run/udev" = {
  #       hostPath = "/run/udev";
  #       isReadOnly = false;
  #     };

  #     "/dev/dri" = {
  #       hostPath = "/dev/dri";
  #       isReadOnly = false;
  #     };

  #     "/run/user/1001/pulse" = {
  #       hostPath = "/run/user/1001/pulse";
  #       isReadOnly = false;
  #     };
  #   };
  #   allowedDevices = [
  #     {
  #       modifier = "rw";
  #       node = "/dev/dri/renderD128";
  #     }
  #     # {
  #     #   modifier = "rwm";
  #     #   node = "/dev/input/event*";
  #     # }
  #     # {
  #     #   modifier = "rwm";
  #     #   node = "/dev/uinput";
  #     # }
  #     {
  #       modifier = "rwm";
  #       node = "/dev/snd";
  #     }
  #   ];
  #   config = {pkgs, ...}: {
  #     environment.systemPackages = with pkgs; [
  #       inputs.self.packages.${system}.prismlauncher-crack
  #       jdk21
  #       glxinfo
  #       kdePackages.qt6ct
  #     ];

  #     environment.variables = {
  #       XDG_RUNTIME_DIR = "/run/user/1001";
  #       WAYLAND_DISPLAY = "wayland-0";
  #       QT_QPA_PLATFORM = "wayland";
  #       PULSE_SERVER = "unix:/run/user/1001/pulse/native";
  #       PIPEWIRE_RUNTIME_DIR = "/run/user/1001";
  #       ALSOFT_DRIVERS = "pulse"; # Force OpenAL to use PulseAudio
  #     };

  #     users.users.${config.lunar.username} = {
  #       uid = 1001;
  #       isNormalUser = true;
  #       initialPassword = config.lunar.username;
  #       extraGroups = ["wheel" "video" "input"]; # Necessary for GPU/input
  #     };

  #     # OpenGL
  #     hardware.graphics = {
  #       enable = true;
  #       enable32Bit = true;
  #     };

  #     hardware.pulseaudio.enable = false;

  #     services.udev.enable = false;

  #     system.stateVersion = "23.11";
  #   };
  # };
  #

  # home-manager.users.${config.lunar.username} = {
  #   imports = [
  #     {
  #       gamix = {
  #         enable = true;
  #         protonGames = {
  #           fdgolf = {
  #             exePath = "/home/${config.lunar.username}/Downloads/Games/4D Golf/4D Golf.exe";
  #             proton = inputs.gamix.packages.${system}.protonPkgs.GE-Proton9-27;
  #             prefixPath = "/home/${config.lunar.username}/Downloads/gamix-test/test/prefixes/test_pfx";
  #           };
  #           silenthill2 = {
  #             exePath = "/mnt/backdrive/Games/Silent Hill 2/SHProto.exe";
  #             proton = inputs.gamix.packages.${system}.protonPkgs.GE-Proton9-27;
  #             prefixPath = "/home/${config.lunar.username}/Downloads/gamix-test/test/prefixes/test_pfx";
  #           };
  #           rdr2 = {
  #             exePath = "/run/media/loystonpais/BA16A4A516A463DB/Games/Red Dead Redemption 2/Launcher.exe";
  #             proton = inputs.gamix.packages.${system}.protonPkgs.GE-Proton7-43;
  #             prefixPath = "/home/${config.lunar.username}/Games/Heroic/Prefixes/default/RDR2";
  #             # gameId = "umu-1174180";
  #           };
  #         };
  #         protonPrefixes = {
  #           "/home/${config.lunar.username}/Downloads/gamix-test/test/prefixes/test_pfx" = {
  #             init = {
  #               tricks = ["vcrun2022" "vcrun2019" "vcrun2015"];
  #               runExes = [
  #                 inputs.gamix.packages.${system}.windowsExes.vc_redist-x86
  #                 inputs.gamix.packages.${system}.windowsExes.vc_redist-x64
  #               ];
  #             };
  #           };
  #         };
  #       };
  #     }
  #   ];
  # };
  #

  system.stateVersion = "23.11"; # Did you read the comment?
}
