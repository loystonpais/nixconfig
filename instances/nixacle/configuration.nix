{
  lib,
  inputs,
  pkgs,
  config,
  ...
}: {
  environment.systemPackages = with pkgs; [
    git
    tmux
    nh
    micro
  ];

  imports = [
    ./lunar.nix
    ./services/nginx.nix
    ./services/gitea.nix
    # ./services/portfolio-website.nix
  ];

  # For minecraft
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [25565 1888];
  };
  # Needed to allow forwarding
  # Otherwise it will fallback to loopback
  services.openssh.settings.GatewayPorts = "yes";

  # Must replace with ssh module configuration
  users.users.${config.lunar.username}.openssh.authorizedKeys.keys = config.lunar.sshPublicKeys;

  home-manager.users.${config.lunar.username}.imports = [
    ({lib, ...}: {
      programs.zsh.oh-my-zsh.theme = lib.mkForce "afowler";
    })
  ];
}
