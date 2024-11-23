{ config, pkgs, ... }:

{
  services.nginx = {
    enable = true;
    user = "www-data";
    workerProcesses = "auto";
    errorLog = "/var/log/nginx/error.log";
    pidFile = "/run/nginx.pid";
    events = {
      workerConnections = 768;
    };

    http = {
      include = [
        "/etc/nginx/modules-enabled/*.conf"
        "/etc/nginx/mime.types"
        "/etc/nginx/conf.d/*.conf"
        "/etc/nginx/sites-enabled/*"
      ];

      gzip = true;

      defaultType = "application/octet-stream";
      sendfile = true;
      tcpNopush = true;
      sslProtocols = [ "TLSv1" "TLSv1.1" "TLSv1.2" "TLSv1.3" ];
      sslPreferServerCiphers = true;

      servers = [
        # Main server for loy.ftp.sh
        {
          serverName = [ "loy.ftp.sh" ];
          listen = [
            { addr = "*"; port = 443; ssl = true; }
          ];
          sslCertificate = "/etc/letsencrypt/live/loy.ftp.sh/fullchain.pem";
          sslCertificateKey = "/etc/letsencrypt/live/loy.ftp.sh/privkey.pem";
          sslDhparam = "/etc/letsencrypt/ssl-dhparams.pem";
          includeFiles = [ "/etc/letsencrypt/options-ssl-nginx.conf" ];

          locations = {
            "/" = {
              root = "/var/www/html";
            };

            "/gitea/" = {
              clientMaxBodySize = "512M";
              proxyPass = "http://localhost:3000/";
              proxySetHeaders = {
                "Connection" = "$http_connection";
                "Upgrade" = "$http_upgrade";
                "Host" = "$host";
                "X-Real-IP" = "$remote_addr";
                "X-Forwarded-For" = "$proxy_add_x_forwarded_for";
                "X-Forwarded-Proto" = "$scheme";
              };
            };
          };
        }

        # Redirect server for git.loy.ftp.sh
        {
          serverName = [ "git.loy.ftp.sh" ];
          listen = [
            { addr = "*"; port = 443; ssl = true; }
          ];
          sslCertificate = "/etc/letsencrypt/live/loy.ftp.sh/fullchain.pem";
          sslCertificateKey = "/etc/letsencrypt/live/loy.ftp.sh/privkey.pem";
          sslDhparam = "/etc/letsencrypt/ssl-dhparams.pem";
          includeFiles = [ "/etc/letsencrypt/options-ssl-nginx.conf" ];

          locations = {
            "/" = {
              return = {
                code = 301;
                uri = "https://loy.ftp.sh/gitea$request_uri";
              };
            };
          };
        }

        # HTTP to HTTPS redirect
        {
          serverName = [ "loy.ftp.sh" ];
          listen = [
            { addr = "*"; port = 80; }
          ];
          locations = {
            "/" = {
              return = {
                code = 301;
                uri = "https://$host$request_uri";
              };
            };
          };
        }
      ];
    };
  };
}
