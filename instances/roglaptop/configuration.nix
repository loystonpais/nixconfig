{
  lib,
  inputs,
  pkgs,
  config,
  system,
  ...
}: {
  imports = [
    ./lunar.nix

    inputs.ataraxy-discord-bot.nixosModules.default
    inputs.portfolio-website.nixosModules.default
    inputs.resumake.nixosModules.default
  ];

  programs.extra-container.enable = true;

  services.ollama = {
    enable = true;
    acceleration = "cuda";
  };

  lunar.specialisations.productive.enable = true;

  # Prevents ollama from redownloading...
  environment.variables.OLLAMA_NOPRUNE = "true";

  lunar.modules.desktop-environments.hyprland.enable = true;

  environment.systemPackages = [
    inputs.idk-shell-command.packages.${system}.default
    pkgs.ungoogled-chromium
    pkgs.cachix
    pkgs.gcc

    (pkgs.vscode-with-extensions.override {
      vscodeExtensions = with pkgs.vscode-extensions; [
        rust-lang.rust-analyzer
      ];
    })
    pkgs.nix-init
  ];

  # Temporarily set asusd package to allow keyboard zones
  # Fix will be available by default in furure
  # services.asusd.package = inputs.self.packages.${system}.asusctl-6-0-12-temp-g513rc-zonefix;

  system.stateVersion = "23.11"; # Did you read the comment?
}
