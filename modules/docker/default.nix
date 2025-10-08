{
  config,
  lib,
  ...
}: {
  options.lunar.modules.docker = {
    enable = lib.mkEnableOption "docker";
    home.enable = lib.mkEnableOption "docker home-manager";
  };

  config = lib.mkIf config.lunar.modules.docker.enable (lib.mkMerge [
    {
      virtualisation.docker.enable = true;
      users.users.${config.lunar.username}.extraGroups = ["docker"];
    }

    {
      lunar.modules.docker.home.enable = lib.mkDefault true;
      home-manager.users.${config.lunar.username}.imports = [
        ./home.nix
      ];
    }
  ]);
}
