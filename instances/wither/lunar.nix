{...}: {
  lunar.hostName = "wither";
  lunar.graphicsMode = "none";
  lunar.bootMode = "bios";

  lunar.sshPublicKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHtN04FVSVonasScikFfltCPFJkSWa3t3z+wo+JA8GGd loyston500@gmail.com"
  ];

  lunar.modules.minecraft.enable = true;
  lunar.modules.desktop-environments.hyprland.enable = false;
  lunar.modules.desktop-environments.plasma.enable = true;
  lunar.modules.multimedia.enable = false;

  lunar.profile.vm.enable = true;
}
