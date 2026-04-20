{den, ...}: {
  den.aspects.nixacle = {
    includes = [
      den.aspects.loystonpais
    ];

    nixos = {
      pkgs,
      lib,
      ...
    }: {
      imports = [
        ./_infect/configuration.nix
      ];

      networking.firewall = {
        enable = true;
        allowedTCPPorts = [25565 80 443];
      };

      security.acme.certs."loy.ftp.sh".listenHTTP = lib.mkForce null;

      services.nginx = {
        enable = true;
        recommendedGzipSettings = true;
        recommendedOptimisation = true;

        virtualHosts."loy.ftp.sh" = {
          enableACME = true;
          forceSSL = true;

          locations = {
            "/" = {
              proxyPass = "http://localhost:5000";
              extraConfig = ''
                client_max_body_size 512M;
                proxy_set_header Connection $http_connection;
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto $scheme;
              '';
            };
          };
        };
      };
    };
  };
}
