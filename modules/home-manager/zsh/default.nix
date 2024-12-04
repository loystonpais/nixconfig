{ config, systemConfig, pkgs, lib, ... }:
{
  config = lib.mkIf systemConfig.vars.modules.home-manager.zsh.enable {
    
    home.packages = with pkgs; [
      lsd
      fastfetch
    ];
    
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autocd = true;
      syntaxHighlighting.enable = true;
      autosuggestion.enable = true;

      shellAliases = rec { 
        ll = "lsd -l";
        ls = "lsd -lh";
        neofetch = "fastfetch";
        changes = "sudo nixos-rebuild dry-activate --fast --flake .#${systemConfig.vars.hostName}";
        test = "sudo nixos-rebuild test --fast --flake .#${systemConfig.vars.hostName}";
        switch = "sudo nixos-rebuild switch --flake .#${systemConfig.vars.hostName}";
        fuckgoback = "sudo nixos-rebuild switch --rollback --flake .#${systemConfig.vars.hostName}";
        fuckgobackasap = rollback;
        rollback = "sudo nixos-rebuild switch --rollback";
        nhswitch = "nh os switch -v -H ${systemConfig.vars.hostName} .";
        switchbutcooler = nhswitch;
        update = "( cd ~/nixconfig && (git pull || git fetch) && changes )";
        upgrade = "( ${update}; cd ~/nixconfig && switch )";
      };
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
  };
}