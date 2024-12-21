{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.vars.modules.samba.enable {
    services.samba = {
      enable = true;
      securityType = "user";
      openFirewall = true;
      extraConfig = ''
        workgroup = WORKGROUP
        server string = smbnix
        netbios name = smbnix
        security = user
        #use sendfile = yes
        #max protocol = smb2
        # note: localhost is the ipv6 localhost ::1
        hosts allow = 192.168.0. 127.0.0.1 localhost
        hosts deny = 0.0.0.0/0
        guest account = nobody
        map to guest = bad user
      '';
      shares = {
        homes = {
          comment = "Home Directories";
          browsable = "yes";
          writable = "no";
        };
      };
    };

    services.samba-wsdd = {
      enable = true;
      openFirewall = false;
    };

    #networking.firewall.enable = true;
    #networking.firewall.allowPing = true;
  };
}
