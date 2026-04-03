{den, ...}: {
  lunar.podman = {user, ...}: {
    nixos = {
      pkgs,
      lib,
      config,
      ...
    }: {
      config = lib.mkMerge [
        {
          virtualisation.podman = {
            enable = true;
            #! TODO dockerCompat = lib.mkDefault true;
          };

          environment.systemPackages = with pkgs; [
            podman-compose
            podman-tui
          ];

          users.users.${user.userName} = {
            extraGroups = ["podman"];
            subGidRanges = [
              {
                count = 65536;
                startGid = 10000;
              }
            ];
            subUidRanges = [
              {
                count = 65536;
                startUid = 10000;
              }
            ];
          };
        }
      ];
    };
  };
}
