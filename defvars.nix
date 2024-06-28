# These are the default vars that are shared to all the instances
# Of course, they can be overridden for each instance
# Change the default values here
# Note: Some are missing default values and thats on purpose
# However, there's nothing stopping you from setting them default values
{ pkgs, lib, config, ...}: 

with lib;

{

  options.vars = {

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

    overlays = {
      enableAll = mkOption {
        type = types.bool;
        description = "enables overlays";
        default = true;
      };
      mc-launcher-patch.enable = mkEnableOption "enables prismlauncer patch";
      supergfxd-lsof-patch.enable = mkEnableOption "enables supergfxd lsof patch";
    };

    modules = {
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
      virtual-machine.enable = mkEnableOption "enables virtual machine";
      waydroid.enable = mkEnableOption "enables waydroid";
      samba.enable = mkEnableOption "enables samba";
      home-manager.enable = mkEnableOption "enables home-manager";
    };

    profile = {
      everything.enable = mkEnableOption "enables almost eveything within the config";
      vm.enable = mkEnableOption "enables vm profile";
    };

    bootMode = mkOption {
      type = types.enum [ "uefi" "bios" ];
      description = "Boot mode";
    };

    graphicsMode = mkOption {
      type = types.enum [ "nvidia" "asuslinux" "none" ];
      description = ''
      GPU specific settings
      nvidia - Basic nvidia gpu settings, uses production pkg
      asuslinux - Nvidia gpu settings with asusd, supergfxctl. 
      '';
    };

  };
}

