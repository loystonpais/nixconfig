{ config, systemConfig, pkgs, ... }:

{
  imports = [
    ./hyprland
  ];

  home.username = systemConfig.vars.username;
  home.homeDirectory = "/home/" + systemConfig.vars.username;

  home.packages = with pkgs; [
    kate # A code editor I like
    nil # Nix server
    nixfmt-classic # Nix formatter
  ];

  home.sessionVariables = { };

  home.file = {
    ".config/kate/lspclient/settings.json".source = ../../assets/kate_lsp.json;
  };

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = systemConfig.vars.github.username;
    userEmail = systemConfig.vars.email;
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
      plugins = [ "git" "direnv" ];
      theme = "robbyrussell";
    };

#     plugins = [
#       {
#         name = "zsh-nix-shell";
#         file = "nix-shell.plugin.zsh";
#         src = pkgs.fetchFromGitHub {
#           owner = "chisui";
#           repo = "zsh-nix-shell";
#           rev = "v0.8.0";
#           sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
#         };
#       }
#     ];

#     initExtra = ''
#       #prompt_nix_shell_setup
#     '';
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableZshIntegration = true;
    };

    home.stateVersion = "23.11";
}
