# UNUSED
{pkgs, ...}: {
  services.openiscsi = {
    enable = true;

    discoverPortal = "ip:port";
    name = "iqn.2015-12.com.oracleiaas:address";
    enableAutoLoginOut = true;
  };

  environment.systemPackages = with pkgs; [
    openiscsi
  ];

  fileSystems."/mnt/datablk1" = {
    device = "/dev/disk/by-label/datablk1";
    fsType = "xfs";
    options = ["_netdev" "nofail"];
  };
}
