# A minecraft setup using modified prismlauncher

{ config, lib, pkgs, settings, ... }:
let

  prismlauncher-patched = pkgs.prismlauncher.overrideAttrs(old: {
    prePatch = ''
      function_name="AccountListPage::on_actionAddOffline_triggered"
      patch_file="./launcher/ui/pages/global/AccountListPage.cpp"

      sed -i "/$function_name/,/^}/ s/return;/\/\/return;/" "$patch_file"
      sed -i 's/You must add a Microsoft account that owns Minecraft before you can add an offline account/Patched Version. Just Ignore/g' "$patch_file"
      sed -i 's/If you have lost your account you can contact Microsoft for support./Skibidi Toilet Ohio Rizz/g' "$patch_file"
    '';
  });
in
{

  environment.systemPackages = [
    prismlauncher-patched
    pkgs.jdk21
  ];
}
