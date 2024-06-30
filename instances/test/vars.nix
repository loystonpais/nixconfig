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

    # ~~ Patches ~~

    # A patch for supergfxd in asuslinux
    # which fixes lsof usage
    ../../options/overlays/supergfxd-lsof-patch.nix


    # A patch for minecraft launcher
    # to allow offline accounts
    ../../options/overlays/mc-launcher-patch.nix


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
