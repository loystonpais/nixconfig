{ config, pkgs, settings, ... }:

{
  home.username = settings.username;
  home.homeDirectory = "/home/" + settings.username;

  home.packages = with pkgs; [ kate nil nixfmt ];

  home.sessionVariables = { AMOGUS = "sus"; };

  home.file = {

  };

  home.stateVersion = "23.11";

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = settings.githubUsername;
    userEmail = settings.email;
    aliases = {
      pu = "push";
      ch = "checkout";
      cm = "commit";
    };
  };

  programs.bash = {
    enable = true;
    shellAliases = { sl = "ls"; };
  };
}
