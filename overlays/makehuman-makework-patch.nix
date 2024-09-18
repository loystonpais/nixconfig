{ config, pkgs, lib, ... }:

let
  # Patch to replace "import imp" with "import importlib as imp"
  # as stated in the github issue
  patch_script = ''
    find . -path "*/9_export_ogre/__init__.py" -exec sed -i 's/import imp/import importlib as imp/' {} \;
  '';

  # As stated in the github issue, add these variables to make it work
  # https://github.com/makehumancommunity/makehuman/issues/213
  pre_fixup_patch = ''
   wrapProgram $out/bin/makehuman \
    --set QT_QPA_PLATFORM xcb \
    --set PYOPENGL_PLATFORM x11
  '';
in {

  config = lib.mkIf config.vars.overlays.makehuman-makework-patch.enable {
    nixpkgs.overlays = [
      (final: prev: {
        makehuman = prev.makehuman.overrideAttrs
          (oldAttrs: {
             postPatch = patch_script;
             preFixup = oldAttrs.preFixup + "\n" + pre_fixup_patch;
         });
      })
    ];
  };
}