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
        description = "enables overlays";
        default = true;
      };
      mc-launcher-patch.enable = mkEnableOption "enables prismlauncer patch";
      supergfxd-lsof-patch.enable = mkEnableOption "enables supergfxd lsof patch";
      makehuman-makework-patch.enable = mkEnableOption "enables makehuman import patch";
    };

    modules = {
      audio.enable = mkEnableOption "enables audio";
      graphics.enable = mkEnableOption "enables graphics";
      hardware.enable = mkEnableOption "enables hardware";

      desktop-environments = {
        enableAll = mkEnableOption "enables all available desktop environments";
        hyprland.enable = mkEnableOption "enables hyprland";
        plasma.enable = mkEnableOption "enables plasma";
      };

      distrobox.enable = mkEnableOption "enables distrobox";
      gamedev.enable = mkEnableOption "enables gamedev";

      gaming.enable = mkEnableOption "enable gaming";

      minecraft.enable = mkEnableOption "enables minecraft";
      multimedia.enable = mkEnableOption "enables multimedia";
      piracy.enable = mkEnableOption "enables piracy";
      program-collection.enable = mkEnableOption "enables program-collection";

      virtual-machine = {
        enable = mkEnableOption "enables virtual machine";
        cgroupDevicesById = mkOption {
          type = types.listOf types.str;
          description = "Devices registered to be passed to the vm";
          default = ["usb-SINO_WEALTH_Gaming_KB-event-kbd" "usb-Razer_Razer_DeathAdder_Essential-event-mouse"];
        };
      };

      android = {
        enable = mkEnableOption "enables android module";
        scrcpy.enable = mkEnableOption "enables scrcpy";
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

      waydroid.enable = mkEnableOption "enables waydroid";
      samba.enable = mkEnableOption "enables samba";
      home-manager = {
        enable = mkEnableOption "enables home manager";
        enableAllModules = mkEnableOption "enables all home configurations";
        hyprland.enable = mkEnableOption "enables hyprland home configuration";
        plasma.enable = mkEnableOption "enables plasma home configuration";
        fonts.enable = mkEnableOption "enables fonts configuration";
        program-collection.enable = mkEnableOption "enables program collection";
        git.enable = mkEnableOption "enables git configuration";
        zsh.enable = mkEnableOption "enables zsh configuration";
        secrets.enable =
          mkEnableOption "enables home secrets configuration (needs secrets module to be enabled)";
      };

      browsers = {
        enable = mkEnableOption "enables browser configuration";
        zen = {
          enable = mkEnableOption "enables zen browser configuration";
        };
      };

      ssh.enable = mkEnableOption "enables ssh";

      secrets = {
        enable = mkEnableOption "enables sops secrets";
        environmentVariablesFromSops = mkOption {
          type = types.attrs;
          default = {};
          description = "environment variables to be set from the sops secrets";
        };
      };
    };

    profile = {
      everything.enable = mkEnableOption "enables almost eveything within the config";
      vm.enable = mkEnableOption "enables vm profile";
      vps.enable = mkEnableOption "enables vps profile (for cloud vps)";
    };

    bootMode = mkOption {
      type = types.enum ["uefi" "bios"];
      description = "Boot mode";
    };

    graphicsMode = mkOption {
      type = types.enum ["nvidia" "asuslinux" "none"];
      description = ''
        GPU specific settings
        nvidia - Basic nvidia gpu settings, uses production pkg
        asuslinux - Nvidia gpu settings with asusd, supergfxctl.
      '';
    };
  };
}
