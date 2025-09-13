{
  config,
  systemConfig,
  pkgs,
  lib,
  inputs,
  system,
  ...
}: {
  home.username = systemConfig.lunar.username;
  home.homeDirectory = "/home/" + systemConfig.lunar.username;

  home.sessionVariables = {};

  home.file = {
    ".config/kate/lspclient/settings.json".source = ../../assets/kate_lsp.json;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };

  programs.ssh = {
    enable = true;
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

  programs.kitty.enableGitIntegration = lib.mkDefault true;
  programs.btop.enable = lib.mkDefault true;
  programs.tmux.enable = lib.mkDefault true;
  programs.zellij.enable = lib.mkDefault true;

  programs.zoxide = {
    enable = lib.mkDefault true;
    enableZshIntegration = lib.mkDefault true;
    enableBashIntegration = lib.mkDefault true;
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
