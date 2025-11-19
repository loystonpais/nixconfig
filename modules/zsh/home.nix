{
  config,
  osConfig,
  pkgs,
  lib,
  inputs,
  ...
}: {
  config = lib.mkIf osConfig.lunar.modules.zsh.home.enable {
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

      localVariables = {
        OLLAMA_NOPRUNE = true;
      };

      shellAliases = rec {
        ll = "lsd -l";
        ls = "lsd -lh";
        neofetch = "fastfetch";
        changes = "sudo nixos-rebuild dry-activate --fast --flake .#${osConfig.lunar.hostName}";
        test = "sudo nixos-rebuild test --fast --flake .#${osConfig.lunar.hostName}";
        switch = "sudo nixos-rebuild switch --flake .#${osConfig.lunar.hostName}";
        fuckgoback = "sudo nixos-rebuild switch --rollback --flake .#${osConfig.lunar.hostName}";
        fuckgobackasap = rollback;
        rollback = "sudo nixos-rebuild switch --rollback";
        nhswitch = "nh os switch -v -H ${osConfig.lunar.hostName} .";
        switchbutcooler = nhswitch;
        update = "( cd ~/nixconfig && (git pull || git fetch) && changes )";
        upgrade = "( ${update}; cd ~/nixconfig && switch )";
        collect = "nix-collect-garbage";
        collectd = "nix-collect-garbage -d";
        cpr = "rsync -avhP --partial --inplace";
        lstr = "ls -tr";
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
    };
  };
}
