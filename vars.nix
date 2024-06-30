{ pkgs, lib, config, ...}: 

with lib;

{

  options.vars = {
    
    hostName = mkOption {
      type = types.str;
      description = "Name of the host";
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

    graphicsOption = mkOption {
      type = types.enum ["nvidia" "asuslinux" ];
      description = ''
      GPU specific settings
      nvidia - Basic nvidia gpu settings, uses production pkg
      asuslinux - Nvidia gpu settings with asusd, supergfxctl. 
      '';
    };
  };
}

