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

  home.stateVersion = "23.11";
}
