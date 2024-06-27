# Settings for the nixconfig
# Can always go to other files if not satisfied
# with the modifications available here
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

    # Contains vm related packages
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

    # Multimedia, includes stremio and vlc
    ./options/modules/multimedia

    # Fonts
    ./options/modules/fonts

    # Samba server, check the file for configurations
    # Mainly set up for vms
    # make sure to set the passwoed using
    # sudo smbpasswd -a <username>
    ./options/modules/samba


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
