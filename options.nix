# Change the default values here
# Note: Some are missing default values and thats on purpose
# However, there's nothing stopping you from setting them default values
{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  options.lunar = {
    name = mkOption {
      type = types.str;
      description = "Name of the user";
      default = "Loyston Pais";
    };

    hostName = mkOption {
      type = types.str;
      description = "Name of the host";
    };

    shell = mkOption {
      type = types.package;
      description = "Default shell package";
      example = pkgs.zsh;
      default = pkgs.zsh;
    };

    username = mkOption {
      type = types.str;
      description = "Username that will be used for the default user";
      default = "loystonpais";
    };

    email = mkOption {
      type = types.str;
      description = "Email address";
      default = "loyston500@gmail.com";
    };

    github = {
      username = mkOption {
        type = types.str;
        description = "Github usename";
        default = "loystonpais";
      };

      email = mkOption {
        type = types.str;
        description = "Github email";
        default = "loyston500@gmail.com";
      };
    };

    timeZone = mkOption {
      type = types.str;
      description = "Time zone";
      default = "Asia/Kolkata";
    };

    locale = mkOption {
      type = types.str;
      description = "Locale";
      default = "en_IN";
    };

    sshPublicKeys = mkOption {
      type = types.listOf types.str;
      description = "Public ssh keys to set as authorized keys";
      # Default not set for obvious reasons
      default = [];
    };

    overlays = {
      enableAll = mkOption {
        type = types.bool;
        description = "overlays";
        default = true;
      };
      mc-launcher-patch.enable = mkEnableOption "prismlauncer patch";
      supergfxd-lsof-patch.enable =
        mkEnableOption "supergfxd lsof patch";
      makehuman-makework-patch.enable =
        mkEnableOption "makehuman import patch";
    };

    specialisations = {
      enable = mkEnableOption "lunar specific specialisations";
      gruvbox.enable = mkEnableOption "enable gruvbox specialisation";
      productive.enable = mkEnableOption "enable productive specialisation";
    };

    modules = {
      vpn = {
        wireguard = {
          enableMode = mkOption {
            type = types.enum ["server" "client" "none"];
            description = "enable wireguard server or client";
            default = "none";
          };
          clientPrivateKeyInSops = mkOption {
            type = types.bool;
            description = ''Looks for private key in sops wireguard-client-{hostname}-private-key'';
            default = true;
          };
        };
      };
      audio.enable = mkEnableOption "audio";
      graphics.enable = mkEnableOption "graphics";
      hardware.enable = mkEnableOption "hardware";

      desktop-environments = {
        enableAll = mkEnableOption "all available desktop environments";
        hyprland.enable = mkEnableOption "hyprland";
        plasma.enable = mkEnableOption "plasma";
      };

      distrobox.enable = mkEnableOption "distrobox";
      gamedev.enable = mkEnableOption "gamedev";

      gaming.enable = mkEnableOption "gaming";

      minecraft.enable = mkEnableOption "minecraft";
      multimedia.enable = mkEnableOption "multimedia";
      piracy.enable = mkEnableOption "piracy";
      program-collection.enable = mkEnableOption "program-collection";

      virtual-machine = {
        enable = mkEnableOption "virtual machine";
        nixvirt.enable = mkEnableOption "NixVirt defined virtual machines";
        cgroupDevicesById = mkOption {
          type = types.listOf types.str;
          description = "Devices registered to be passed to the vm";
          default = [
            "usb-SINO_WEALTH_Gaming_KB-event-kbd"
            "usb-Razer_Razer_DeathAdder_Essential-event-mouse"
          ];
        };
      };

      android = {
        enable = mkEnableOption "android module";
        scrcpy.enable = mkEnableOption "scrcpy";
        phone.ip = mkOption {
          type = types.str;
          description = ''
            Default device IP. To set a static ip for your android device run as root:
            `ip address add 192.168.43.1/24 dev wlan0`
          '';
          default = "192.168.43.1";
        };
        phone.port = mkOption {
          type = types.int;
          description = "Default device port";
          default = 5555;
        };
      };

      waydroid.enable = mkEnableOption "waydroid";
      samba.enable = mkEnableOption "samba";
      home-manager = {
        enable = mkEnableOption "home manager";
        enableAllModules = mkEnableOption "all home configurations";
        hyprland.enable = mkEnableOption "hyprland home configuration";
        plasma.enable = mkEnableOption "plasma home configuration";
        fonts.enable = mkEnableOption "fonts configuration";
        program-collection.enable = mkEnableOption "program collection";
        git.enable = mkEnableOption "git configuration";
        zsh.enable = mkEnableOption "zsh configuration";
        secrets.enable =
          mkEnableOption
          "home secrets configuration (needs secrets module to be enabled)";
        zed.enable = mkEnableOption "zed editor configuration";
      };

      browsers = {
        enable = mkEnableOption "browser configuration";
        zen = {enable = mkEnableOption "zen browser configuration";};
      };

      ssh.enable = mkEnableOption "ssh";

      secrets = {
        enable = mkEnableOption "sops secrets";
        environmentVariablesFromSops = mkOption {
          type = types.attrs;
          default = {};
          description = "environment variables to be set from the sops secrets";
        };
      };

      nixvim = {
        enable = mkEnableOption "nixvim";
      };

      winapps.enable = mkEnableOption "winapps";

      rclone = {
        mega500.enable = mkEnableOption "rclone mega500";
        mega800.enable = mkEnableOption "rclone mega800";
        mega200.enable = mkEnableOption "rclone mega200";
        dropbox500.enable = mkEnableOption "rclone dropbox500";
        pcloud500.enable = mkEnableOption "rclone pcloud500";
        box500.enable = mkEnableOption "rclone box500";
        koofr500.enable = mkEnableOption "rclone box500";

        # Unions
        unions.all.enable = mkEnableOption "enables union of all remotes";
        unions.mega.enable = mkEnableOption "enables union of all mega remotes";
      };
    };

    profile = {
      everything.enable =
        mkEnableOption "almost everything within the config";
      vm.enable = mkEnableOption "vm profile";
      vps.enable = mkEnableOption "vps profile (for cloud vps)";
    };

    bootMode = mkOption {
      type = types.enum ["uefi" "bios" "dontmanage"];
      description = "Boot mode";
    };

    graphicsMode = mkOption {
      type = types.enum ["nvidia" "asuslinux" "none" "dontmanage"];
      description = ''
        GPU specific settings
        nvidia - Basic nvidia gpu settings, uses production pkg
        asuslinux - Nvidia gpu settings with asusd, supergfxctl.
        dontmanage - Is totally ignored by lunar.
      '';
    };
  };
}
