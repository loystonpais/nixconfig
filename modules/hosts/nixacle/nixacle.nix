{den, ...}: {
  den.aspects.nixacle = {
    includes = [
      den.aspects.loystonpais
    ];

    nixos = {
      pkgs,
      lib,
      ...
    }: {
      imports = [
        ./_infect/configuration.nix
      ];

      networking.firewall = {
        enable = lib.mkForce false;
        allowedTCPPorts = [25565 1888];
      };
    };
  };
}
