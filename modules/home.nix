{
  config,
  osConfig,
  pkgs,
  lib,
  inputs,
  system,
  ...
}: {
  home.username = osConfig.lunar.username;
  home.homeDirectory = "/home/" + osConfig.lunar.username;

  home.sessionVariables = {};

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        setEnv = {
          # https://ghostty.org/docs/help/terminfo#configure-ssh-to-fall-back-to-a-known-terminfo-entry
          TERM = "xterm-256color";
        };
      };
      # pureintent = {
      #   forwardAgent = true;
      # };
    };
  };

  # This is the default config
  programs.ssh.matchBlocks."*" = {
    forwardAgent = false;
    addKeysToAgent = "no";
    compression = false;
    serverAliveInterval = 0;
    serverAliveCountMax = 3;
    hashKnownHosts = false;
    userKnownHostsFile = "~/.ssh/known_hosts";
    controlMaster = "no";
    controlPath = "~/.ssh/master-%r@%n:%p";
    controlPersist = "no";
  };

  programs.kitty.enableGitIntegration = lib.mkDefault true;
  programs.btop.enable = lib.mkDefault true;
  programs.tmux.enable = lib.mkDefault true;
  programs.zellij.enable = lib.mkDefault true;

  programs.zoxide = {
    enable = lib.mkDefault true;
    enableZshIntegration = lib.mkDefault true;
    enableBashIntegration = lib.mkDefault true;
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = lib.mkDefault "zen.desktop";
      "text/markdown" = lib.mkDefault "zeditor.desktop";
      "text/plain" = lib.mkDefault "zeditor.desktop";
      "application/pdf" = lib.mkDefault "okular.desktop";
      "x-scheme-handler/http" = lib.mkDefault "zen.desktop";
      "x-scheme-handler/https" = lib.mkDefault "zen.desktop";
    };
  };

  home.packages = lib.mkMerge [
    (
      # TODO: Maybe add an option to enable templates
      lib.mkIf true (builtins.attrValues (builtins.mapAttrs
        (name: attrs: pkgs.writeShellScriptBin ("template-" + name) "nix flake new -t ${inputs.self}#${name} $@")
        inputs.self.templates))
    )

    (
      # TODO: Maybe add an option to enable templates
      lib.mkIf true (let
        subMenus = builtins.attrValues (builtins.mapAttrs
          (name: attrs: {
            inherit name;
            text = ''
              [Desktop Action ${name}]
              Name=${builtins.replaceStrings ["-"] [" "] name}
              Icon=document-new-from-template
              Exec=${pkgs.nix}/bin/nix flake new -t ${inputs.self}#${name} "%f"
            '';
          })
          inputs.self.templates);

        initializeTemplate = pkgs.lunar.writeKioServiceMenu "initialize-template" ''
          [Desktop Entry]
          Type=Service
          X-KDE-ServiceTypes=KonqPopupMenu/Plugin
          MimeType=inode/directory;
          Actions=${builtins.concatStringsSep ";" (map (a: a.name) subMenus)};
          X-KDE-Priority=TopLevel
          Icon=accessories-text-editor
          X-KDE-Submenu=Initialize Nix Template

          ${builtins.concatStringsSep "\n\n" (map (a: a.text) subMenus)}
        '';
      in [initializeTemplate])
    )
  ];

  home.stateVersion = "23.11";
}
