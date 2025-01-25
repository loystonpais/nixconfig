{
  lib,
  inputs,
  pkgs,
  config,
  ...
}: {
  environment.systemPackages = with pkgs; [
    git
    tmux
    nh
    micro
  ];

  imports = [
    ./lunar.nix
  ];

  # Must replace with ssh module configuration
  users.users.${config.lunar.username}.openssh.authorizedKeys.keys = config.lunar.sshPublicKeys;
}
