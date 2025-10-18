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
  };
}
