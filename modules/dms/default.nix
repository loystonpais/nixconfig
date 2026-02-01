{
  config,
  lib,
  pkgs,
  ...
}: {
  options.lunar.modules.dms = {
    enable = lib.mkEnableOption "dankshell";
    home.enable = lib.mkEnableOption "dankshell home-manager";
  };

  config = lib.mkIf config.lunar.modules.dms.enable (lib.mkMerge [
    {
      lunar.modules.dms.home.enable = lib.mkDefault true;
      home-manager.users.${config.lunar.username}.imports = [
        ./home.nix
      ];
    }

    # Greeter
    {
      services.displayManager.dms-greeter = {
        enable = true;
        configHome = config.home-manager.users.${config.lunar.username}.home.homeDirectory;
      };
    }

    # Qt themes need this to work
    {
      environment.systemPackages = with pkgs; [
        kdePackages.qt6ct

        libsForQt5.qt5ct
      ];
    }

    # Terminal
    {
      lunar.modules.kitty.enable = lib.mkDefault true;
    }

    # Add icons
    {
      environment.systemPackages = with pkgs; [
        (whitesur-icon-theme.override {
          alternativeIcons = true;
          boldPanelIcons = true;
        })
        whitesur-cursors

        papirus-icon-theme
      ];
    }

    # Important pkgs
    {
      environment.systemPackages = with pkgs; [
        kdePackages.dolphin
        kdePackages.ark
        kdePackages.gwenview
        kdePackages.spectacle
      ];
    }

    #* Unrelated. This is only unabled if home is disabled
    (lib.mkIf (!config.lunar.modules.dms.home.enable) (lib.mkMerge [
      {
        programs.dms-shell = {
          enable = true;

          systemd = {
            enable = true; # Systemd service for auto-start
            restartIfChanged = true; # Auto-restart dms.service when dms-shell changes
          };

          # Core features
          enableSystemMonitoring = true; # System monitoring widgets (dgop)
          enableClipboard = true; # Clipboard history manager
          enableVPN = true; # VPN management widget
          enableDynamicTheming = true; # Wallpaper-based theming (matugen)
          enableAudioWavelength = true; # Audio visualizer (cava)
          enableCalendarEvents = true; # Calendar integration (khal)
        };
      }

      # {
      #   services.dbus.enable = true;
      #   security.polkit.enable = true;
      # }
    ]))
  ]);
}
