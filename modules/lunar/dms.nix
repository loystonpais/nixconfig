{
  den,
  inputs,
  lunar,
  ...
}: {
  lunar.dms = {
    includes = [
      lunar.kitty
    ];
    nixos = {
      pkgs,
      config,
      ...
    }: {
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

    homeManager = {
      pkgs,
      lib,
      config,
      ...
    }: let
      set-dms-dolphin-theme = pkgs.writeShellScriptBin "set-dms-dolphin-theme" ''
        touch "${config.home.homeDirectory}/.config/dolphinrc" || true
        ${lib.getExe pkgs.initool} set "${config.home.homeDirectory}/.config/dolphinrc" UiSettings ColorScheme DankMatugen > "${config.home.homeDirectory}/.config/dolphinrc"
      '';
    in {
      imports = [
        inputs.dms.homeModules.dank-material-shell
      ];

      systemd.user.services.dms = {
        Service = {
          Environment = [
            "QT_QPA_PLATFORMTHEME=qt6ct"
            "QT_QPA_PLATFORMTHEME_QT6=qt6ct"
          ];

          UnsetEnvironment = "QT_STYLE_OVERRIDE";
        };
      };

      programs.niri.settings = {
        environment = {
          QT_QPA_PLATFORMTHEME = "qt6ct";
          QT_QPA_PLATFORMTHEME_QT6 = "qt6ct";
          QT_STYLE_OVERRIDE = "";
        };

        spawn-at-startup = [
          {argv = ["${lib.getExe set-dms-dolphin-theme}"];}
        ];
      };

      home.packages = [set-dms-dolphin-theme];

      programs.dank-material-shell = {
        enable = true;
      };

      #? Are these needed ?
      dconf.enable = true;
      dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
    };

    provides.greeter = {user, ...}: {
      nixos = {config, ...}: {
        services.displayManager.dms-greeter = {
          enable = true;
          configHome = config.home-manager.users.${user.userName}.home.homeDirectory;
        };
      };
    };

    provides.via-systemd = {
      homeManager = {...}: {
        programs.dank-material-shell = {
          systemd = {
            enable = true;
            restartIfChanged = true;
          };
        };
      };
    };

    provides.via-niri = {
      nixos = {...}: {
        # Disable niri-flake's own polkit to allow dms's own
        # NOTE: This USER service is defined in NIXOS not homeManager
        systemd.user.services.niri-flake-polkit.enable = false;
      };

      homeManager = {
        lib,
        config,
        ...
      }: {
        imports = [
          inputs.dms.homeModules.niri
        ];
        programs.dank-material-shell = {
          niri = {
            enableSpawn = true;
          };
        };

        #! Just make it work for now
        xdg.configFile.niri-config-dms.text =
          (
            lib.mkIf
            (config.home.file.".config/niri/mutable.kdl" or {enable = false;}).enable
          )
          ''
            include "./mutable.kdl"
          '';
      };
    };
  };
}
