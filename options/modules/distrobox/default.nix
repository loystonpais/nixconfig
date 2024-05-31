{ config, lib, pkgs, settings, ... }:

let
    # NOTE: This only handles btrfs
    storageDriver = if config.fileSystems."/".fsType == "btrfs" then "btrfs" else null;
in
{
  environment.systemPackages = with pkgs; [
    distrobox
  ];

  # Using docker with distrobox
  virtualisation.docker.enable = true;

  # Apparently it needs to know whether root is btrfs or not
  virtualisation.docker.storageDriver = storageDriver;

  # Adding user to the docker group
  users.users.${settings.username}.extraGroups = [ "docker" ];

}
