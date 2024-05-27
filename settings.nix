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


  optionalModules = [
     # Contains kdeconnect, gparted, compsize
     ./options/modules/app-list-1

     # Contains vm related things
     ./options/modules/virtual-machine

    # Contains gaming related packages
    ./options/modules/gaming

    # Minecraft setup using patched p*ismlauncher
    ./options/modules/minecraft


  ];

  # Select option nvidia, asuslinux
  graphicsSetting = "asuslinux";

  # Set boot type
  # Default is UEFI
  # NOTE Remove this comment once if making it true works
  biosBoot = false;

  hostname = "nixos";
  system = "x86_64-linux";
}
