{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.lunar.modules.distrobox.enable {
    environment.systemPackages = with pkgs; [distrobox];

    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
    };

    environment.etc."distrobox/distrobox.conf".text = ''
      container_additional_volumes="/nix/store:/nix/store:ro /etc/profiles/per-user:/etc/profiles/per-user:ro /etc/static/profiles/per-user:/etc/static/profiles/per-user:ro"
    '';

    users.users.${config.lunar.username} = {
      extraGroups = ["podman"];
      subGidRanges = [
        {
          count = 65536;
          startGid = 1000;
        }
      ];
      subUidRanges = [
        {
          count = 65536;
          startUid = 1000;
        }
      ];
    };
  };
}
