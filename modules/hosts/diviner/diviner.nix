{den, ...}: {
  den.aspects.diviner = {
    includes = [
      den.aspects.loystonpais
    ];

    nixos = {pkgs, ...}: {
      environment.systemPackages = with pkgs; [
        tmux
        nh
        bat
      ];
    };
  };
}
