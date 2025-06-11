{
  pkgs,
  lib,
  inputs,
  osConfig,
  system,
  config,
  ...
}: {
  imports = [];

  options = {
    lunar.plasma = {
      mode = lib.mkOption {
        type = lib.types.enum ["productive" "default"];
        default = "default";
      };
    };
  };

  config = lib.mkIf osConfig.lunar.modules.home-manager.plasma.enable (lib.mkMerge [
    {
      home.packages = with pkgs; [
        whitesur-kde
        (whitesur-icon-theme.override {
          alternativeIcons = true;
          boldPanelIcons = true;
        })
        whitesur-cursors
        whitesur-gtk-theme
        inputs.self.packages.${system}.kwin-modern-informative
      ];

      qt = {
        enable = true;
        style.name = "kvantum";
      };

      ## GTK Theminng

      # makes some gtk apps (not libadwaita) apps pick up
      # custom theme
      home.sessionVariables.GTK_THEME = "WhiteSur-Dark";

      # Fixes theme polarity (light/dark) between several gtk4?
      # apps such as gparted and libadwaita apps such as bottles
      xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [xdg-desktop-portal-gtk];
        configPackages = with pkgs; [xdg-desktop-portal-gtk];
      };

      home.file = {
        ".local/share/fonts/InterVariable.ttf".source = ../../../assets/fonts/InterVariable.ttf;
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
          "kwinrc"."Plugins" = {
            "shakecursorEnabled" = {value = false;};
            #"karouselEnabled" = true;
          };

          "baloofilerc"."Basic Settings"."Indexing-Enabled" = {
            value = false;
            immutable = true;
          };

          "kwinrc"."TabBox"."LayoutName" = "modern_informative";
          "kwinrc"."org.kde.kdecoration2"."ButtonsOnLeft" = "XAI";
          "kwinrc"."org.kde.kdecoration2"."ButtonsOnRight" = "FB";

          "kdeglobals"."KDE"."widgetStyle" = {
            value = "kvantum-dark";
            immutable = true;
          };
        };

        fonts = {
          general = {
            family = "Inter Variable";
            pointSize = 10;
            weight = 400;
          };
          fixedWidth = {
            family = "Fira Code";
            pointSize = 10;
            weight = 400;
          };
          small = {
            family = "Inter Variable";
            pointSize = 8;
            weight = 400;
          };
          toolbar = {
            family = "Inter Variable";
            pointSize = 10;
            weight = 400;
          };
          menu = {
            family = "Inter Variable";
            pointSize = 10;
            weight = 400;
          };
          windowTitle = {
            family = "Inter Variable";
            pointSize = 10;
            weight = 400;
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
                    (lib.elem pkgs.vscode osConfig.environment.systemPackages)
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

      programs.konsole = {
        enable = true;
        customColorSchemes = {
          #DarkPastelsModified = inputs.self.outPath + "/assets/konsole/themes/DarkPastelsModified.colorscheme";
          DarkPastelsModified = ../../../assets/konsole/themes/DarkPastelsModified.colorscheme;
        };
        defaultProfile = "Lunar";
        profiles = {
          Lunar = {
            colorScheme = "DarkPastelsModified";
            extraConfig = {
              # converted to nix code from the old .profile file
              Appearance = {
                AntiAliasFonts = true;
                BoldIntense = true;
                ColorScheme = "DarkPastelsModified";
                Font = "Fira Code Light,10,-1,5,25,0,0,0,0,0,Regular";
                TabColor = "27,30,32,0";
                UseFontLineCharacters = false;
                WordModeBrahmic = false;
              };

              "Cursor Options" = {
                CursorShape = 2;
                UseCustomCursorColor = false;
              };

              General = {
                InvertSelectionColors = false;
                # Name = "Lunar";
                Parent = "FALLBACK/";
                SemanticUpDown = false;
                TerminalCenter = false;
              };

              "Interaction Options" = {
                OpenLinksByDirectClickEnabled = true;
                TextEditorCmd = 1;
                UnderlineFilesEnabled = true;
              };

              Keyboard = {
                KeyBindings = "default";
              };

              Scrolling = {
                HistoryMode = 1;
              };

              "Terminal Features" = {
                BlinkingCursorEnabled = true;
              };
            };
          };
        };
      };
    }

    (
      lib.mkIf (config.lunar.plasma.mode == "productive")
      {
        programs.plasma = let
          wallpaper = "${inputs.self}/assets/wallpapers/green-leaves.jpg";
        in {
          kscreenlocker.appearance.wallpaper = lib.mkForce wallpaper;
          workspace.wallpaper = lib.mkForce wallpaper;
          panels = lib.mkForce [
            {
              location = "bottom";
              floating = true;
              height = 44;
              hiding = "normalpanel";
              lengthMode = "fill";
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
                    launchers = [
                      "applications:org.kde.dolphin.desktop"
                      "applications:org.kde.konsole.desktop"
                    ];
                  };
                }

                "org.kde.plasma.pager"
                "org.kde.plasma.systemtray"
                "org.kde.plasma.digitalclock"
                "org.kde.plasma.showdesktop"
              ];
            }
          ];
        };
      }
    )
  ]);
}
