{supergfxctl, ...}: let
  lsofPatch = ''
    patch_file="./src/lib.rs"
    if grep -q 'if !PathBuf::from("/usr/bin/lsof").exists() {' $patch_file; then
      sed -i '/if !PathBuf::from("\/usr\/bin\/lsof").exists() {/,/}/s/^\s*return Ok(());\s*$//' $patch_file
      sed -i 's/warn!("The lsof util is missing from your system, please ensure it is available so processes hogging Nvidia can be nuked");/warn!("Using lsof");/' $patch_file
    else
      echo "Patch failed."
      exit 1
    fi '';
in
  supergfxctl.overrideAttrs (p: {
    version = p.version + "-lsof-fix";
    prePatch = lsofPatch;
  })
