{den, ...}: {
  lunar.distrobox = {
    nixos = {pkgs, ...}: {
      environment.systemPackages = with pkgs; [
        distrobox
      ];

      environment.etc."distrobox/distrobox.conf".text = ''
        container_additional_volumes="/nix:/nix /etc/profiles/per-user:/etc/profiles/per-user:ro /etc/static/profiles/per-user:/etc/static/profiles/per-user:ro /run/current-system/sw:/run/current-system/sw:ro"
      '';
    };
  };
}
