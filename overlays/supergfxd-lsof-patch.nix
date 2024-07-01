{ config, pkgs, lib, ... }:

let
  patch_script = ''
    patch_file="./src/lib.rs"
    if grep -q 'if !PathBuf::from("/usr/bin/lsof").exists() {' $patch_file; then
      sed -i '/if !PathBuf::from("\/usr\/bin\/lsof").exists() {/,/}/s/^\s*return Ok(());\s*$//' $patch_file
      sed -i 's/warn!("The lsof util is missing from your system, please ensure it is available so processes hogging Nvidia can be nuked");/warn!("Using lsof");/' $patch_file
    else
      echo "Patch failed."
      exit 1
    fi '';
in {

  config = lib.mkIf config.vars.overlays.supergfxd-lsof-patch.enable {
    # Add lsof to path because it is missing in the pkg config
    systemd.services.supergfxd.path = [ pkgs.lsof ];

    # Patch the package so that lsof usage is not ignored
    nixpkgs.overlays = [
      (final: prev: {
        supergfxctl = prev.supergfxctl.overrideAttrs
          (oldAttrs: { prePatch = patch_script; });
      })
    ];
  };
}
