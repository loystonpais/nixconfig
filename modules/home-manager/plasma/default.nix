{
  pkgs,
  lib,
  systemConfig,
  ...
}: {
  imports = [];

  config = lib.mkIf systemConfig.vars.modules.home-manager.plasma.enable {
    home.packages = with pkgs; [
      whitesur-kde
      whitesur-icon-theme
      whitesur-cursors
      whitesur-gtk-theme
      (callPackage ../../../derivations/kwin-modern-informative {})
    ];

    qt = {
      enable = true;
      style.name = "kvantum";
    };

    xdg.configFile = {
      "Kvantum/WhiteSur".source = "${pkgs.whitesur-kde}/share/Kvantum/WhiteSur";

      "Kvantum/kvantum.kvconfig".text = ''
        [General]
        theme=WhiteSurDark
      '';
    };

    programs.plasma = {
      overrideConfig = true;
      enable = true;
      windows.allowWindowsToRememberPositions = true;

      kscreenlocker.appearance.wallpaper = "${pkgs.whitesur-kde}/share/wallpapers/WhiteSur-dark/contents/images/3840x2160.jpg";
      kscreenlocker.autoLock = false;

      powerdevil = {
        AC.autoSuspend.action = "nothing";
        AC.whenLaptopLidClosed = "doNothing";
        AC.powerProfile = "performance";
        AC.turnOffDisplay.idleTimeout = "never";

        battery.autoSuspend.action = "nothing";
        battery.whenLaptopLidClosed = "doNothing";

        batteryLevels.criticalAction = "shutDown";
        batteryLevels.criticalLevel = 5;
        batteryLevels.lowLevel = 20;
        lowBattery.powerProfile = "powerSaving";
      };

      configFile = {
        "kwinrc"."Plugins"."shakecursorEnabled" = {value = false;};

        "baloofilerc"."Basic Settings"."Indexing-Enabled" = {
          value = false;
          immutable = true;
        };

        # NOTE: need to get these working
        "kdeglobals"."General"."font" = "Inter Variable,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
        "kdeglobals"."General"."menuFont" = "Inter Variable,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
        "kdeglobals"."General"."smallestReadableFont" = "Inter Variable,8,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
        "kdeglobals"."General"."toolBarFont" = "Inter Variable,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
        "kdeglobals"."WM"."activeFont" = "Inter Variable,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
        "kdeglobals"."General"."fixed" = "Fira Code,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";

        "kwinrc"."TabBox"."LayoutName" = "modern_informative";
        "kwinrc"."org.kde.kdecoration2"."ButtonsOnLeft" = "XAI";
        "kwinrc"."org.kde.kdecoration2"."ButtonsOnRight" = "FB";

        "kdeglobals"."KDE"."widgetStyle" = {
          value = "kvantum-dark";
          immutable = true;
        };
      };

      workspace = {
        # cannot be used because it applies default splash screen
        # lookAndFeel = "com.github.vinceliuice.WhiteSur-dark";

        theme = "WhiteSur-dark";
        cursor.theme = "WhiteSur-cursors";
        iconTheme = "WhiteSur-dark";
        colorScheme = "WhiteSurDark";
        windowDecorations.theme = "__aurorae__svg__WhiteSur-dark";
        windowDecorations.library = "org.kde.kwin.aurorae";
        wallpaper = "${pkgs.whitesur-kde}/share/wallpapers/WhiteSur-dark/contents/images/3840x2160.jpg";
        splashScreen = {
          theme = "None";
          engine = "none";
        };
      };

      panels = [
        {
          location = "bottom";
          floating = true;
          height = 44;
          hiding = "autohide";
          lengthMode = "fit";
          screen = "all";

          widgets = [
            {
              kickoff = {
                sortAlphabetically = true;
                icon = "nix-snowflake-white";
              };
            }

            {
              iconTasks = {
                launchers =
                  [
                    "applications:org.kde.dolphin.desktop"
                    "applications:org.kde.konsole.desktop"
                  ]
                  ++
                  # This is to add if the package is installed
                  lib.optional
                  (lib.elem pkgs.vscode systemConfig.environment.systemPackages)
                  "applications:code.desktop";
              };
            }
          ];
        }

        {
          location = "top";
          floating = true;
          height = 40;
          hiding = "dodgewindows";
          lengthMode = "fit";
          alignment = "right";
          screen = "all";

          widgets = [
            "org.kde.plasma.pager"
            "org.kde.plasma.systemtray"
            "org.kde.plasma.digitalclock"
            "org.kde.plasma.showdesktop"
          ];
        }
      ];
    };
  };
}
