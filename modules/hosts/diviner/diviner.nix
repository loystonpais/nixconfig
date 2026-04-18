{den, ...}: {
  den.aspects.diviner = {
    includes = [
      den.aspects.loystonpais
    ];

    nixos = {pkgs, ...}: {
      imports = [
        ./_infect/configuration.nix
      ];

      environment.systemPackages = with pkgs; [
        tmux
        nh
        bat
      ];
    };
  };
}
