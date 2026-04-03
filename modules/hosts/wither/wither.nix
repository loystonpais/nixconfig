{den, ...}: {
  den.aspects.wither = {
    includes = [
      den.aspects.loystonpais
      den.aspects.determinate
      den.aspects.plasma
      den.aspects.multimedia
      den.aspects.sops
      den.aspects.audio
      den.aspects.hardware
      den.aspects.graphics
      den.aspects.minecraft
      den.aspects.ssh
    ];

    nixos = {...}: {
      virtualisation.diskSize = 30 * 1024;
      system.stateVersion = "23.11";
    };
  };
}
