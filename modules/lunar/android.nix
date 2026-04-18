{den, ...}: {
  lunar.android = {
    user,
    enableScrcpy ? true,
    ...
  }: {
    nixos = {pkgs, lib, ...}: {
      environment.systemPackages = with pkgs; [
        android-tools
      ] ++ (lib.optionals enableScrcpy [pkgs.scrcpy]);

      users.users.${user.userName}.extraGroups = ["adbusers"];
    };
  };
}
