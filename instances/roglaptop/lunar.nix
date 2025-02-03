{...}: {
  lunar.hostName = "roglaptop";
  lunar.graphicsMode = "asuslinux";
  lunar.bootMode = "uefi";

  lunar.sshPublicKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHtN04FVSVonasScikFfltCPFJkSWa3t3z+wo+JA8GGd loyston500@gmail.com"
  ];

  # Default VPN
  lunar.modules.vpn.wireguard.enableMode = "client";

  # Set your profile
  lunar.profile.everything.enable = true;

  # Exclusion
  lunar.modules.browsers.zen.enable = true;
  lunar.modules.waydroid.enable = false;
  lunar.modules.samba.enable = false;
}
