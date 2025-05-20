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

  home.file."Books" = {
    source = inputs.self.packages.${system}.goalkicker-books;
    recursive = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };

  home.packages = lib.mkMerge [
    (
      # TODO: Maybe add an option to enable templates
      lib.mkIf true (builtins.attrValues (builtins.mapAttrs
        (name: attrs: pkgs.writeShellScriptBin ("template-" + name) "nix flake new -t ${inputs.self}#${name} $@")
        inputs.self.templates))
    )
  ];

  home.stateVersion = "23.11";
}
