{den, ...}: {
  den.aspects.diviner = {
    includes = [
      den.aspects.loystonpais
      den.aspects.determinate
      den.aspects.sops
      den.aspects.hardware
      den.aspects.dev
      den.aspects.ssh
    ];

    nixos = {pkgs, ...}: {
      environment.systemPackages = with pkgs; [tmux nh bat];
      boot.kernelPackages = pkgs.linuxPackages_6_12;
    };

    homeManager = {lib, ...}: {
      programs.zsh.oh-my-zsh.theme = lib.mkForce "afowler";
    };
  };
}
