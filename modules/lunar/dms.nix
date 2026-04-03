{
  den,
  inputs,
  lunar,
  ...
}: {
  lunar.dms = {
    host,
    user,
    ...
  }: {
    includes = [
      lunar.kitty
    ];
    nixos = {
      pkgs,
      config,
      ...
    }: {
      services.displayManager.dms-greeter = {
        enable = true;
        configHome = config.home-manager.users.${user.userName}.home.homeDirectory;
      };

      environment.systemPackages = with pkgs; [
        kdePackages.qt6ct
        libsForQt5.qt5ct

        (whitesur-icon-theme.override {
          alternativeIcons = true;
          boldPanelIcons = true;
        })
        whitesur-cursors

        papirus-icon-theme

        kdePackages.dolphin
        kdePackages.ark
        kdePackages.gwenview
        kdePackages.spectacle

        nautilus
      ];

      services.upower.enable = true;
      services.power-profiles-daemon.enable = true;
      services.accounts-daemon.enable = true;
    };

    homeManager = {pkgs, ...}: {
      imports = [inputs.dms.homeModules.default];

      programs.dank-material-shell = {
        enable = true;

        systemd = {
          enable = true;
          restartIfChanged = true;
        };
      };

      systemd.user.services.dms.Service.Environment = [
        "QT_QPA_PLATFORMTHEME=qt6ct"
        "QT_QPA_PLATFORMTHEME_QT6=qt6ct"
      ];

      # Temp fix, place a file for niri to pick up
      home.file.".config/niri/dms-env-vars.kdl".text = ''
        environment {
          QT_QPA_PLATFORMTHEME "qt6ct"
          QT_QPA_PLATFORMTHEME_QT6 "qt6ct"
        }
      '';

      dconf.enable = true;
      dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
    };
  };
}
