{...}: {
  imports = [
    ./hardware-configuration.nix
  ];

  # Workaround for https://github.com/NixOS/nix/issues/8502
  services.logrotate.checkConfig = false;

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = false;
  networking.hostName = "diviner";
  networking.domain = "subnet08061458.vcn08061458.oraclevcn.com";
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHtN04FVSVonasScikFfltCPFJkSWa3t3z+wo+JA8GGd loyston500@gmail.com''];
  system.stateVersion = "23.11";
}
