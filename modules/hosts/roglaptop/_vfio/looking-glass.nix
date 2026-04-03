{
  pkgs,
  lib,
  ...
}: {
  config = lib.mkMerge [
    {
      # To recreate the file if deleted run
      #  sudo systemd-tmpfiles --create /etc/tmpfiles.d/00-nixos.conf
      systemd.tmpfiles.rules = ["f /dev/shm/looking-glass 0660 1001 kvm -"];
      environment.systemPackages = with pkgs; [
        looking-glass-client
      ];
    }

    (lib.mkIf ((lib.strings.hasSuffix "-B7" pkgs.looking-glass-client.name) != true) {
      warnings = [
        "Looking Glass Client version is no longer B7. Might need to update windows drivers"
      ];
    })
  ];
}
