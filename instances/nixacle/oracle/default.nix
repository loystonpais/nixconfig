{ lib, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot.tmp.cleanOnBoot = lib.mkForce true;
  zramSwap.enable = lib.mkForce true;
  networking.hostName = lib.mkForce "nixacle";
  networking.domain = lib.mkForce  "subnet08061458.vcn08061458.oraclevcn.com";
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];
  services.openssh.enable = lib.mkForce true;
  users.users.root.openssh.authorizedKeys.keys = lib.mkForce 
    [''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHtN04FVSVonasScikFfltCPFJkSWa3t3z+wo+JA8GGd loyston500@gmail.com'' ];
  system.stateVersion = lib.mkForce "23.11";
  nix.settings.experimental-features =  lib.mkForce [ "nix-command" "flakes" ];
}