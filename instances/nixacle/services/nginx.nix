{ config, ... }:
let 
  datablock = config.vars.nixacle.datablock1;
	address = config.vars.nixacle.address;
in
{

  networking.firewall = { 
    enable = true; 
    allowedTCPPorts = [ 80 443 ]; 
  };
    
	services.nginx = {
		enable = true;

		virtualHosts.${address} = {
		  #addSSL = true;
		  #enableACME = true;

		  locations = {
				"/" = {
					root = "${datablock.path}/www/html";
				};

				"/gitea" = {
					# Gitea runs locally at port 3000 
					proxyPass = "http://127.0.0.1:3000";
				};

			};
			
		};
	};
}
