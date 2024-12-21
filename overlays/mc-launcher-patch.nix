{
  lib,
  config,
  ...
}: let
  patch_script = ''
    function_name="AccountListPage::on_actionAddOffline_triggered"
    patch_file="./launcher/ui/pages/global/AccountListPage.cpp"

    sed -i "/$function_name/,/^}/ s/return;/\/\/return;/" "$patch_file"
    sed -i 's/You must add a Microsoft account that owns Minecraft before you can add an offline account/Patched Version. Just Ignore/g' "$patch_file"
    sed -i 's/If you have lost your account you can contact Microsoft for support./Skibidi Toilet Ohio Rizz/g' "$patch_file"
  '';
in {
  config = lib.mkIf config.vars.overlays.mc-launcher-patch.enable {
    nixpkgs.overlays = [
      (final: prev: {
        prismlauncher-unwrapped =
          prev.prismlauncher-unwrapped.overrideAttrs
          (oldAttrs: {prePatch = patch_script;});
      })
    ];
  };
}
