{den, ...}: {
  lunar.android = {
    user,
    enableScrcpy ? true,
    ...
  }: {
    nixos = {
      pkgs,
      lib,
      ...
    }: {
      environment.systemPackages = with pkgs;
        [
          android-tools
        ]
        ++ (lib.optionals enableScrcpy [pkgs.scrcpy]);

      users.users.${user.userName}.extraGroups = ["adbusers"];
    };

    homeManager = {...}: {
      home.shellAliases = {
        "adb-call-pick" = "adb shell input keyevent KEYCODE_CALL";
        "adb-call-end" = "adb shell input keyevent KEYCODE_ENDCALL";

        "adb-button-power" = "adb shell input keyevent 26";
      };
    };
  };
}
