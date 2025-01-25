{
  lib,
  config,
  pkgs,
  ...
}:
with lib; {
  config = mkIf config.lunar.profile.vps.enable {
    lunar.modules.home-manager = {
      enable = mkDefault true;
      git.enable = mkDefault true;
      zsh.enable = mkDefault true;
      secrets.enable = mkDefault true;
    };

    lunar.modules.ssh.enable = mkDefault true;
    lunar.modules.secrets.enable = mkDefault true;
  };
}
