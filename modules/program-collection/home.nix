{
  osConfig,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf osConfig.lunar.modules.program-collection.home.enable {
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
      alejandra # Nix formatter
      ruby
      jq
      yq
      bat
      xonsh
      rsync
    ];
  };
}
