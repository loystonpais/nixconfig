{
  config,
  lib,
  pkgs,
  ...
}: {
  options.lunar.modules.podman = {
    enable = lib.mkEnableOption "podman";
    home.enable = lib.mkEnableOption "podman home-manager";
  };

  config = lib.mkIf config.lunar.modules.podman.enable (lib.mkMerge [
    {
      lunar.modules.podman.home.enable = lib.mkDefault true;
      home-manager.users.${config.lunar.username}.imports = [
        ./home.nix
      ];
    }

    {
      virtualisation.podman = {
        enable = true;
        dockerCompat = lib.mkIf (!config.lunar.modules.docker.enable) (lib.mkDefault true);
      };

      environment.systemPackages = with pkgs; [
        podman-compose
        podman-tui
      ];

      users.users.${config.lunar.username} = {
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
  ]);
}
