# Only modify this
# DO NOT modify the imports in configurations.nix or anywhere else
# Only modify outside this if things don't work

{
  username = "loystonvm";
  name = "Loyston Pais";
  email = "loyston500@gmail.com";
  githubUsername = "loystonpais";
  timeZone = "Asia/Kolkata";
  defaultLocale = "en_IN";

  # Select option nvidia, asuslinux
  graphicsSetting = "nvidia";

  # Set boot type
  # Default is UEFI
  # NOTE Remove this comment once if making it true works
  biosBoot = false;

  hostname = "nixos";
  system = "x86_64-linux";
}
