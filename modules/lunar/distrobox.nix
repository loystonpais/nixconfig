{den, ...}: {
  lunar.distrobox = {
    nixos = {pkgs, ...}: {
      environment.systemPackages = with pkgs; [
        distrobox
        host-spawn
      ];

      environment.etc."distrobox/distrobox.conf".text = ''
        container_additional_volumes="/nix/store:/nix/store:ro /etc/profiles/per-user:/etc/profiles/per-user:ro /etc/static/profiles/per-user:/etc/static/profiles/per-user:ro /run/current-system/sw:/run/current-system/sw:ro"
        container_init_hook="echo 'export PATH=\"/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:\$PATH\"' > /etc/profile.d/fix-nixos-path.sh"
      '';
    };
  };
}
