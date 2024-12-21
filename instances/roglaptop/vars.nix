{...}: {
  vars.hostName = "roglaptop";
  vars.graphicsMode = "asuslinux";
  vars.bootMode = "uefi";

  vars.sshPublicKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHtN04FVSVonasScikFfltCPFJkSWa3t3z+wo+JA8GGd loyston500@gmail.com"
  ];

  # Set your profile
  vars.profile.everything.enable = true;

  # Exclusion
  vars.modules.browsers.zen.enable = true;
  vars.modules.waydroid.enable = false;
  vars.modules.samba.enable = false;
}
