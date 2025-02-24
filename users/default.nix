{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../options.nix
  ];

  config = {
    users.users.${config.lunar.username} = {
      isNormalUser = true;
      description = config.lunar.name;
      extraGroups = ["networkmanager" "wheel" "disk"];
      shell = config.lunar.shell;
      initialPassword = config.lunar.username;
      packages = [];
    };

    programs.zsh.enable =
      if config.lunar.shell == pkgs.zsh
      then true
      else false;
  };
}
