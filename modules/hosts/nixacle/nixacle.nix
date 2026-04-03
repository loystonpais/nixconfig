{den, ...}: {
  den.aspects.nixacle = {
    includes = [
      den.aspects.loystonpais
      den.aspects.determinate
      den.aspects.sops
      den.aspects.dev
      den.aspects.ssh
    ];

    nixos = {
      pkgs,
      lib,
      ...
    }: {
      environment.systemPackages = with pkgs; [
        tmux
        nh
      ];

      services.tailscale.enable = true;

      networking.firewall = {
        enable = lib.mkForce false;
        allowedTCPPorts = [25565 1888];
      };

      services.openssh.settings.GatewayPorts = "yes";

      boot.loader.efi.canTouchEfiVariables = lib.mkForce false;
    };
  };
}
