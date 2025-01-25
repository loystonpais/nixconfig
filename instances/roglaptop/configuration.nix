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

  /*
    services.ataraxy-discord-bot = {
    enable = false;
    envFilePath = config.sops.secrets.ataraxy_environment_file.path;
  };
  */

  /*
    services.portfolio-website = {
    enable = true;
    port = 3005;
  };
  */

  programs.extra-container.enable = true;

  #! Temporary fix
  /*nixpkgs.overlays = [
      (final: prev: {
        patool =
          prev.patool.overrideAttrs
          (oldAttrs: {
            doCheck = false;
            doInstallCheck = false;
            pytestCheckPhase = false;
          });
      })

      (self: super: {
      electron_31 = self.electron;
    })
  ];*/

  services.ollama = {
    enable = true;
    acceleration = "cuda";
  };

  lunar.modules.desktop-environments.hyprland.enable = false;

  /*services.auto-resume-builder = {
    enable = true;
    envFilePath = config.sops.secrets.auto-resume-builder.path;
  };*/

  environment.systemPackages = [
    inputs.idk-shell-command.packages.${system}.default

    # pkgs.warp-terminal

    pkgs.ungoogled-chromium
    #pkgs.jetbrains.webstorm
    #pkgs.jetbrains.rust-rover

    # Cachix is needed for uploading
    # the cache, not downloading it
    pkgs.cachix
    # pkgs.bitwarden-cli

    pkgs.gcc

    # pkgs.zed-editor

    (pkgs.vscode-with-extensions.override {
      vscodeExtensions = with pkgs.vscode-extensions; [
        rust-lang.rust-analyzer
      ];
    })

    pkgs.nix-init
  ];

  /*networking.interfaces.wlo1.ipv4.addresses = [ {
    address = "192.168.5.9";
    prefixLength = 24;
  } ];*/

  system.stateVersion = "23.11"; # Did you read the comment?
}
