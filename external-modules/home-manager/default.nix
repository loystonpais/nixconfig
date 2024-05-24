{ config, pkgs, settings, inputs, ... }:

{
  home.username = settings.username;
  home.homeDirectory = "/home/" + settings.username;

  home.packages = with pkgs; [
    kate # A code editor I like
    nil # Nix server
    nixfmt # Nix formatter
  ];

  home.sessionVariables = {};

  home.file = {
    ".config/kate/lspclient/settings.json".source = ../../assets/kate_lsp.json;
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
