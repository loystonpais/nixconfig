{
  systemConfig,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf systemConfig.vars.modules.home-manager.program-collection.enable {
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
