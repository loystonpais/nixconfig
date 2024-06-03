# Only modify this
# DO NOT modify the imports in configurations.nix or anywhere else
# Only modify outside this if things don't work
{
  username = "loystonpais";
  name = "Loyston Pais";
  email = "loyston500@gmail.com";
  githubUsername = "loystonpais";
  timeZone = "Asia/Kolkata";
  defaultLocale = "en_IN";


  optionalImports = [
     # Contains kdeconnect, gparted, compsize
     ./options/modules/app-list-1

     # Contains vm related things
     ./options/modules/virtual-machine

    # Contains gaming related packages
    ./options/modules/gaming

    # Minecraft setup with prismlauncher
    ./options/modules/minecraft

    # Gamedev packages, godot
    ./options/modules/gamedev

    # Piracy tools
    ./options/modules/piracy

    # Distrobox setup with docker
    ./options/modules/distrobox

    # Waydroid
    ./options/modules/waydroid


    # ~~ Patches ~~

    # A patch for supergfxd in asuslinux
    # which fixes lsof usage
    ./options/overlays/supergfxd-lsof-patch.nix


    # A patch for minecraft launcher
    # to allow offline accounts
    ./options/overlays/mc-launcher-patch.nix


  ];

  # Select option nvidia, asuslinux
  # asuslinux module includes a patch
  graphicsSetting = "asuslinux";

  # Set boot type
  # Default is UEFI
  # NOTE Remove this comment once if making it true works
  biosBoot = false;

  hostname = "nixos";
  system = "x86_64-linux";
}
