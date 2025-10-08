{
  lib,
  config,
  pkgs,
  ...
}:
with lib; {
  config = mkIf config.lunar.profile.vps.enable {
    lunar.modules = {
      git.enable = mkDefault true;
      zsh.enable = mkDefault true;
      secrets.enable = mkDefault true;
      ssh.enable = mkDefault true;
    };
  };
}
