{
  osConfig,
  config,
  inputs,
  pkgs,
  lib,
  ...
}: {
  imports = [
    inputs.dms.homeModules.dank-material-shell
  ];

  config = lib.mkIf osConfig.lunar.modules.dms.enable (lib.mkMerge [
    (lib.mkIf osConfig.lunar.modules.dms.home.enable (lib.mkMerge [
      {
        programs.dank-material-shell = {
          enable = true;

          systemd = {
            enable = true;
            restartIfChanged = true;
          };
        };
      }
    ]))

    # https://danklinux.com/docs/dankmaterialshell/application-themes?_highlight=theme
    # We avoid using home.sessionVariables because that will mess with plasma
    {
      # First set env vars for dms service itself
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
    }

    # Setting style for plasma via kvantum and whitesur theme
    {
      xdg.configFile = {
        "Kvantum/WhiteSur".source = "${pkgs.whitesur-kde}/share/Kvantum/WhiteSur";
      };

      home.packages = with pkgs; [
        kdePackages.qtstyleplugin-kvantum
      ];
    }

    {
      home.packages = with pkgs; [
        kdePackages.breeze
        kdePackages.breeze-gtk
      ];
    }

    # Force gtk to prefer dark I guess
    {
      dconf.enable = true;
      dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
    }
  ]);
}
