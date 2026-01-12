# Change the default values here
# Note: Some are missing default values and thats on purpose
# However, there's nothing stopping you from setting them default values
{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  patterns = {
    identifier = "[a-zA-Z_][a-zA-Z0-9_]*";
    ipAddress = "^([0-9]{1,3}\\.){3}[0-9]{1,3}$";
  };
in {
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
      default = pkgs.xonsh;
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
      default = "en_US.UTF-8";
    };

    sshPublicKeys = mkOption {
      type = types.listOf types.str;
      description = "Public ssh keys to set as authorized keys";
      # Default not set for obvious reasons
      default = [];
    };

    expensiveBuilds = mkOption {
      type = types.bool;
      description = "enables expensive builds";
      default = true;
    };

    flakePath = mkOption {
      type = types.str;
      description = "Path to nixconfig";
      default = "/etc/nixos";
    };

    wallpaper = mkOption {
      type = types.nullOr types.str;
      description = "Path to wallpaper";
      default = null;
    };

    specialisations = {
      enable = mkEnableOption "lunar specific specialisations";
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

      distrobox.enable = mkEnableOption "distrobox";
      gamedev.enable = mkEnableOption "gamedev";

      gaming.enable = mkEnableOption "gaming";

      # minecraft moved to modules
      # multimedia moved to modules
      piracy.enable = mkEnableOption "piracy";
      misc.enable = mkEnableOption "misc";

      virtual-machine = {
        enable = mkEnableOption "virtual machine";
        nixvirt.enable = mkEnableOption "NixVirt defined virtual machines";
        cgroupDevices = mkOption {
          type = types.listOf types.str;
          description = "Devices registered to be passed to the vm";
          example = [
            "/dev/input/by-id/usb-SINO_WEALTH_Gaming_KB-event-kbd"
            "/dev/input/by-id/usb-Razer_Razer_DeathAdder_Essential-event-mouse"
          ];
          apply = unique;
        };
      };

      android = {
        enable = mkEnableOption "android module";
        scrcpy.enable = mkEnableOption "scrcpy";
        adbDevices = mkOption {
          description = ''
            Default device IP. To set a static ip for your android device run as root:
            `ip address add 192.168.43.1/24 dev wlan0`
          '';
          type = types.attrsOf (types.submodule {
            options = {
              ip = mkOption {
                type = types.strMatching patterns.ipAddress;
              };
              port = mkOption {
                type = types.port;
                default = 5555;
              };
            };
          });
        };
      };

      waydroid.enable = mkEnableOption "waydroid";
      samba.enable = mkEnableOption "samba";

      # browsers moved to modules

      ssh.enable = mkEnableOption "ssh";

      secrets = {
        enable = mkEnableOption "sops secrets";
        environmentVariablesFromSops = mkOption {
          type = types.attrs;
          default = {};
          description = "environment variables to be set from the sops secrets";
        };
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
