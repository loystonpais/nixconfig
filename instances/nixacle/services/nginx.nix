{ ... }:
let 
  rootPathPrefix = "/mnt/datablk1";
in
{

    networking.firewall = { 
      enable = true; 
      allowedTCPPorts = [ 80 443 ]; 
    };
    
	services.nginx = {
		enable = true;

		virtualHosts."loy.us.to" = {
		  #addSSL = true;
		  #enableACME = true;
		  #root = "/mnt/datablk1/www/html";	
		  locations."/" = {
		  	root = "${rootPathPrefix}/www/html";
		  };
		};
	};
}
