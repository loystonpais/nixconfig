{
  systemConfig,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf systemConfig.lunar.modules.home-manager.program-collection.enable {
    home.packages = with pkgs; [
      nil # Nix server

      # useful sh commands
      zoxide
      lsd
      fd
      tldr
      tmux
      broot
      ripgrep
      compsize
      nixfmt-classic # Nix formatter
    ];
  };
}
