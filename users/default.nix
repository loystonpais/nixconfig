{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../defvars.nix
  ];

  config = {
    users.users.${config.vars.username} = {
      isNormalUser = true;
      description = config.vars.name;
      extraGroups = ["networkmanager" "wheel" "disk"];
      shell = config.vars.shell;
      packages = [];
    };

    programs.zsh.enable =
      if config.vars.shell == pkgs.zsh
      then true
      else false;
  };
}
