{
  config,
  systemConfig,
  pkgs,
  ...
}: {
  home.username = systemConfig.lunar.username;
  home.homeDirectory = "/home/" + systemConfig.lunar.username;

  home.sessionVariables = {};

  home.file = {
    ".config/kate/lspclient/settings.json".source = ../../assets/kate_lsp.json;
  };

  programs.home-manager.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };

  home.stateVersion = "23.11";
}
