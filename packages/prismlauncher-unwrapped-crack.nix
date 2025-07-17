{
  prismlauncher-unwrapped,
  stdenv,
  msaClientID ? null,
  gamemodeSupport ? stdenv.hostPlatform.isLinux,
}: let
  patchOfflineTrigger = ''
    function_name="AccountListPage::on_actionAddOffline_triggered"
    patch_file="./launcher/ui/pages/global/AccountListPage.cpp"

    sed -i "/$function_name/,/^}/ s/return;/\/\/return;/" "$patch_file"
    sed -i 's/You must add a Microsoft account that owns Minecraft before you can add an offline account/Patched Version. Just Ignore/g' "$patch_file"
    sed -i 's/If you have lost your account you can contact Microsoft for support./Skibidi Toilet Ohio Rizz/g' "$patch_file"
  '';

  patchOwnsMinecraft = ''
    if grep -q 'bool ownsMinecraft() const { return data.type != AccountType::Offline && data.minecraftEntitlement.ownsMinecraft; }' ./launcher/minecraft/auth/MinecraftAccount.h; then
      sed -i 's|bool ownsMinecraft() const { return data.type != AccountType::Offline && data.minecraftEntitlement.ownsMinecraft; }|bool ownsMinecraft() const { return true; }|' ./launcher/minecraft/auth/MinecraftAccount.h
    else
      echo "Pattern not found."
      exit 1
    fi
  '';
in
  (
    prismlauncher-unwrapped.overrideAttrs
    (p: {
      version = p.version + "-crack";
      prePatch = (p.prePatch or "") + patchOfflineTrigger + "\n\n" + patchOwnsMinecraft;
      __intentionallyOverridingVersion = true;
    })
  ).override {inherit msaClientID gamemodeSupport;}
