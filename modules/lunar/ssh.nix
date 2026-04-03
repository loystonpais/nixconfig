{den, ...}: {
  lunar.ssh = {
    nixos = {...}: {
      services.openssh = {
        enable = true;
        ports = [22];
        settings = {
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
          X11Forwarding = false;
          PermitRootLogin = "prohibit-password";
        };
      };

      networking.firewall.allowedTCPPorts = [22];

      programs.mosh.enable = true;
      networking.firewall.allowedUDPPortRanges = [
        {
          from = 60000;
          to = 61000;
        }
      ];
    };
  };
}
