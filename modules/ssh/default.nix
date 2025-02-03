{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.lunar.modules.ssh.enable {
    services.openssh = {
      enable = true;
      ports = [22];
      settings = {
        PasswordAuthentication = false;
        AllowUsers = [config.lunar.username];
        UseDns = true;
        X11Forwarding = false;
        PermitRootLogin = "prohibit-password";
      };
    };

    # Allowing the port 22
    networking.firewall = {
      enable = true;
      allowedTCPPorts = [22];
    };

    users.users.${config.lunar.username}.openssh.authorizedKeys.keys = config.lunar.sshPublicKeys;

    programs.mosh = {
      enable = true;
      openFirewall = true;
    };
  };
}
