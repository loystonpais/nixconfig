{
  config,
  lib,
  inputs,
  system,
  ...
}: {
  config = lib.mkIf config.lunar.modules.winapps.enable {
    environment.systemPackages = [
      inputs.winapps.packages."${system}".winapps
      inputs.winapps.packages."${system}".winapps-launcher
    ];

    virtualisation.docker.enable = true;
    virtualisation.docker.storageDriver =
      # NOTE: This only handles btrfs
      if config.fileSystems."/".fsType == "btrfs"
      then "btrfs"
      else null;

    # Adding user to the docker group
    users.users.${config.lunar.username}.extraGroups = ["docker"];

    # Provides cache
    nix.settings = {
      substituters = ["https://winapps.cachix.org/"];
      trusted-public-keys = ["winapps.cachix.org-1:HI82jWrXZsQRar/PChgIx1unmuEsiQMQq+zt05CD36g="];
    };
  };
}
