{ config, lib, pkgs, ... }:
with lib; {
  imports = [ ./zen.nix ];

  config = mkIf config.lunar.modules.browsers.enable {
    programs.firefox = {
      enable = true;
      preferences = {"widget.use-xdg-desktop-portal.file-picker" = 1;};
    };
    lunar.modules.browsers.zen.enable = true;
  };
}
