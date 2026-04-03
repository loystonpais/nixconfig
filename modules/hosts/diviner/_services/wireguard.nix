{lib, pkgs, config, ...}: {
  networking.nat.enable = true;
  networking.nat.externalInterface = "eth0";
  networking.nat.internalInterfaces = ["wg0"];
  networking.firewall.allowedUDPPorts = [51820];

  networking.wireguard.interfaces.wg0 = {
    ips = ["10.100.0.1/24"];
    listenPort = 51820;

    postSetup = ''
      ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
    '';

    postShutdown = ''
      ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
    '';

    privateKeyFile = config.sops.secrets.wireguard-server-common-private-key.path;

    peers = [{
      publicKey = "VlJsakwwGty/KyGGXwDQiNl44iXr5aVAuUS5pVpVg2g=";
      allowedIPs = ["10.100.0.3/32"];
    }];
  };
}
