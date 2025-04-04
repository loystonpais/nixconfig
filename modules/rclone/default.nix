# mounts go at /mnt/rclone/<name>
{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (builtins) map listToAttrs attrNames;
  inherit (lib.generators) toINI;

  # Edit this
  allRemotes = ["mega800" "box500" "koofr500" "pcloud500" "dropbox500"];

  # Edit this
  unionConfig = {
    # All seems to be buggy
    # Unable to calculate size
    # Files from some remotes dont appear
    all = {
      type = "union";
      upstreams = "mega800: box500: koofr500: pcloud500: dropbox500:";
      cache_time = 120;
    };
    mega = {
      type = "union";
      upstreams = "mega800: mega500:";
      cache_time = 120;
    };
  };

  allUnions = attrNames unionConfig;

  mkDefaultMountPath = name: "/mnt/rclone/" + name;
  mkRcloneFsWithConfig = remoteName: configPath: {
    device = "${remoteName}:/";
    fsType = "rclone";
    options = [
      "nodev"
      "nofail"
      "allow_other"
      "args2env"
      "config=${configPath}"
    ];
  };
  mkRcloneFsWithSecretConfig = name: secret: mkRcloneFsWithConfig name secret.path;
  mkRcloneFsWithRcloneIniSecret = name: mkRcloneFsWithSecretConfig name config.sops.secrets."rclone.conf";
  mkRcloneFsWithRcloneUnionIniTemplate = name: mkRcloneFsWithSecretConfig name config.sops.templates."rclone-with-unions.conf";
in {
  config = {
    environment.systemPackages = with pkgs; [rclone];
    sops.templates."rclone-with-unions.conf".content = ''
      ${config.sops.placeholder."rclone.conf"}

      ${toINI {} unionConfig}
    '';
    fileSystems = let
      individualMounts = listToAttrs (map (remoteName: {
          name = mkDefaultMountPath remoteName;
          value = lib.mkIf config.lunar.modules.rclone.${remoteName}.enable (mkRcloneFsWithRcloneIniSecret remoteName);
        })
        allRemotes);

      unionMounts = listToAttrs (map (unionName: {
          name = mkDefaultMountPath unionName;
          value = lib.mkIf config.lunar.modules.rclone.unions.${unionName}.enable (mkRcloneFsWithRcloneUnionIniTemplate unionName);
        })
        allUnions);
    in
      individualMounts // unionMounts;
  };
}
