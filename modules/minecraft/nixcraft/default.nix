{
  config,
  lib,
  inputs,
  ...
}: {
  imports = [inputs.nixcraft.nixosModules.default];

  options.lunar.modules.nixcraft = {
    enable = lib.mkEnableOption "nixcraft";
    home.enable = lib.mkEnableOption "nixcraft home-manager";
  };

  config = lib.mkIf config.lunar.modules.nixcraft.enable (lib.mkMerge [
    {
      lunar.modules.nixcraft.home.enable = lib.mkDefault true;
      home-manager.users.${config.lunar.username}.imports = [
        ./home.nix
      ];
    }

    {
      nixcraft = {
        enable = true;
        server = {
          instances = {
            superb-server = {
              version = "1.21.1";
              agreeToEula = true;
              enable = true;
              java.memory = 2000;
              serverProperties = {
                level-seed = "6969";
                online-mode = false;
                bug-report-link = null;
              };
              # servers can be run as systemd user services
              # service name is set as nixcraft-server-<name>.service
              service = {
                enable = true;
                autoStart = false;
              };
            };
          };
        };
      };
    }
  ]);
}
