{config, ...}: let
  datablock = config.vars.nixacle.datablock1;
  address = config.vars.nixacle.address;
in {
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [80 443];
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = config.vars.email;
  };

  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;

    virtualHosts.${address} = {
      enableACME = true;
      forceSSL = true;

      locations = {
        "/resume/" = {
          alias = "/var/lib/auto-resume-builder/build/";
          extraConfig = ''
             index resume.pdf;
            default_type application/pdf;
            add_header Content-Disposition 'inline';
          '';
        };

        "/" = {
          # Portfolio Website runs at port 3001
          proxyPass = "http://localhost:3001";
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

        "/gitea/" = {
          # Gitea runs locally at port 3000
          proxyPass = "http://localhost:3000/";
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
}
