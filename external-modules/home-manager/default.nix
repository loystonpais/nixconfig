{ config, pkgs, settings, inputs, ... }:

{
  home.username = settings.username;
  home.homeDirectory = "/home/" + settings.username;

  home.packages = with pkgs; [
    kate # A code editor I like
    nil # Nix server
    nixfmt # Nix formatter
  ];

  home.sessionVariables = { };

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

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autocd = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;

    shellAliases = { ll = "ls -l"; };
    history = {
      size = 10000000;
      save = 10000000;
      ignoreSpace = true;
      ignoreDups = true;
      ignoreAllDups = true;
      expireDuplicatesFirst = true;
      extended = true;
      share = true;
      path = "${config.home.homeDirectory}/.zsh_history";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "robbyrussell";
    };
  };

}
