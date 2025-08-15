# Lot of stuff copied from https://github.com/sodiboo/system
{
  lib,
  pkgs,
  inputs,
  config,
  osConfig,
  ...
}: {
  imports = [
    # DO NOT import this as its already done by the os module
    # inputs.niri-flake.homeModules.niri
  ];

  config = lib.mkIf osConfig.lunar.modules.niri.home.enable (lib.mkMerge [
    {
      # Programs needed for niri
      programs = {
        kitty.enable = true;
        ghostty.enable = true;
        fuzzel.enable = true;
        waybar = {
          enable = true;
          systemd.enable = true;
        };
        pqiv.enable = lib.mkDefault true;
      };

      xdg.mimeApps.defaultApplications = {
        "image/png" = "pqiv.desktop";
        "image/jpeg" = "pqiv.desktop";
        "image/gif" = "pqiv.desktop";
        "image/webp" = "pqiv.desktop";
      };

      home.packages = with pkgs; [
        wl-clipboard
        wayland-utils
        libsecret
        swaybg
        alacritty
        kitty
        xwayland-satellite-unstable
        pavucontrol
        libnotify
        playerctl
      ];

      # services.mako.enable = lib.mkDefault true;
      services.swaync.enable = lib.mkDefault true;
    }

    ( # Niri
      {
        programs.niri.settings = with config.lib.niri.actions; let
          sh = spawn "sh" "-c";
          notifDaemon =
            if config.services.mako.enable
            then "mako"
            else if config.services.swaync.enable
            then "swaync"
            else null;
        in {
          prefer-no-csd = true;

          spawn-at-startup =
            [
              # Waybar
              {command = ["sh" "-c" "systemctl --user reset-failed waybar.service"];}
              {command = ["sh" "-c" "systemctl --user restart waybar.service"];}
            ]
            ++ (
              lib.lists.optionals (notifDaemon != null) # Notification daemon
              
              [
                {command = ["sh" "-c" "systemctl --user reset-failed ${notifDaemon}.service"];}
                {command = ["sh" "-c" "systemctl --user restart ${notifDaemon}.service"];}
              ]
            );

          xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite-unstable;

          binds = {
            "XF86AudioRaiseVolume".action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+"];
            "XF86AudioLowerVolume".action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-"];
            "XF86AudioMute".action = sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";

            "Mod+T".action = spawn "ghostty";
            "Mod+D".action = spawn "fuzzel";
            "Mod+Q".action = close-window;
            "Mod+E".action = spawn "code";
            "Mod+Shift+E".action = spawn "zeditor";
            "Mod+M".action = sh "prismlauncher -l FSG";
            "Mod+S".action = spawn "stremio";
            "Mod+B".action = spawn "zen";
            "Mod+X".action = spawn (lib.getExe pkgs.wl-kbptr);
            "Mod+Shift+B".action = spawn "brave";
            "Mod+Shift+Ctrl+Alt+P".action = sh "shutdown now";

            # Playerctl stuff
            "Mod+Space".action = sh "playerctl play-pause";
            "Mod+Alt+Right".action = sh "playerctl position 5+";
            "Mod+Alt+Left".action = sh "playerctl position 5-";

            "Print".action = screenshot;
            #"Ctrl-Print".action = screenshot-screen;
            "Alt+Print".action = screenshot-window;

            "Mod+Shift+Q".action = quit;
            "Ctrl+Alt+Delete".action = quit;

            "Mod+Shift+P".action = power-off-monitors;

            "Mod+Left".action = focus-column-left;
            "Mod+Down".action = focus-window-down;
            "Mod+Up".action = focus-window-up;
            "Mod+Right".action = focus-column-right;
            "Mod+H".action = focus-column-left;
            "Mod+J".action = focus-window-down;
            "Mod+K".action = focus-window-up;
            "Mod+L".action = focus-column-right;

            "Mod+Ctrl+Left".action = move-column-left;
            "Mod+Ctrl+Down".action = move-window-down;
            "Mod+Ctrl+Up".action = move-window-up;
            "Mod+Ctrl+Right".action = move-column-right;
            "Mod+Ctrl+H".action = move-column-left;
            "Mod+Ctrl+J".action = move-window-down;
            "Mod+Ctrl+K".action = move-window-up;
            "Mod+Ctrl+L".action = move-column-right;

            "Mod+Home".action = focus-column-first;
            "Mod+End".action = focus-column-last;
            "Mod+Ctrl+Home".action = move-column-to-first;
            "Mod+Ctrl+End".action = move-column-to-last;

            "Mod+Shift+Left".action = focus-monitor-left;
            "Mod+Shift+Down".action = focus-monitor-down;
            "Mod+Shift+Up".action = focus-monitor-up;
            "Mod+Shift+Right".action = focus-monitor-right;
            "Mod+Shift+H".action = focus-monitor-left;
            "Mod+Shift+J".action = focus-monitor-down;
            "Mod+Shift+K".action = focus-monitor-up;
            "Mod+Shift+L".action = focus-monitor-right;

            "Mod+Shift+Ctrl+Left".action = move-column-to-monitor-left;
            "Mod+Shift+Ctrl+Down".action = move-column-to-monitor-down;
            "Mod+Shift+Ctrl+Up".action = move-column-to-monitor-up;
            "Mod+Shift+Ctrl+Right".action = move-column-to-monitor-right;
            "Mod+Shift+Ctrl+H".action = move-column-to-monitor-left;
            "Mod+Shift+Ctrl+J".action = move-column-to-monitor-down;
            "Mod+Shift+Ctrl+K".action = move-column-to-monitor-up;
            "Mod+Shift+Ctrl+L".action = move-column-to-monitor-right;

            "Mod+Page_Down".action = focus-workspace-down;
            "Mod+Page_Up".action = focus-workspace-up;
            "Mod+U".action = focus-workspace-down;
            "Mod+I".action = focus-workspace-up;
            "Mod+Ctrl+Page_Down".action = move-column-to-workspace-down;
            "Mod+Ctrl+Page_Up".action = move-column-to-workspace-up;
            "Mod+Ctrl+U".action = move-column-to-workspace-down;
            "Mod+Ctrl+I".action = move-column-to-workspace-up;

            "Mod+Shift+Page_Down".action = move-workspace-down;
            "Mod+Shift+Page_Up".action = move-workspace-up;
            "Mod+Shift+U".action = move-workspace-down;
            "Mod+Shift+I".action = move-workspace-up;

            "Mod+WheelScrollDown" = {
              cooldown-ms = 150;
              action = focus-workspace-down;
            };

            "Mod+WheelScrollUp" = {
              cooldown-ms = 150;
              action = focus-workspace-up;
            };

            "Mod+Ctrl+WheelScrollDown" = {
              cooldown-ms = 150;
              action = move-column-to-workspace-down;
            };

            "Mod+Ctrl+WheelScrollUp" = {
              cooldown-ms = 150;
              action = move-column-to-workspace-up;
            };

            "Mod+WheelScrollRight".action = focus-column-right;
            "Mod+WheelScrollLeft".action = focus-column-left;
            "Mod+Ctrl+WheelScrollRight".action = move-column-right;
            "Mod+Ctrl+WheelScrollLeft".action = move-column-left;

            "Mod+Shift+WheelScrollDown".action = focus-column-right;
            "Mod+Shift+WheelScrollUp".action = focus-column-left;
            "Mod+Ctrl+Shift+WheelScrollDown".action = move-column-right;
            "Mod+Ctrl+Shift+WheelScrollUp".action = move-column-left;

            "Mod+1".action = focus-workspace "1";
            "Mod+2".action = focus-workspace "2";
            "Mod+3".action = focus-workspace "3";
            "Mod+4".action = focus-workspace "4";
            "Mod+5".action = focus-workspace "5";
            "Mod+6".action = focus-workspace "6";
            "Mod+7".action = focus-workspace "7";
            "Mod+8".action = focus-workspace "8";
            "Mod+9".action = focus-workspace "9";

            # "Mod+Ctrl+1".action = move-column-to-workspace "1";
            # "Mod+Ctrl+2".action = move-column-to-workspace "2";
            # "Mod+Ctrl+3".action = move-column-to-workspace "3";
            # "Mod+Ctrl+4".action = move-column-to-workspace "4";
            # "Mod+Ctrl+5".action = move-column-to-workspace "5";
            # "Mod+Ctrl+6".action = move-column-to-workspace "6";
            # "Mod+Ctrl+7".action = move-column-to-workspace "7";
            # "Mod+Ctrl+8".action = move-column-to-workspace "8";
            # "Mod+Ctrl+9".action = move-column-to-workspace "9";

            "Mod+BracketLeft".action = consume-or-expel-window-left;
            "Mod+BracketRight".action = consume-or-expel-window-right;

            "Mod+Comma".action = consume-window-into-column;
            "Mod+Period".action = expel-window-from-column;

            "Mod+R".action = switch-preset-column-width;
            "Mod+Shift+R".action = switch-preset-window-height;
            "Mod+Ctrl+R".action = reset-window-height;

            "Mod+F".action = maximize-column;
            "Mod+Shift+F".action = fullscreen-window;
            "Mod+Ctrl+F".action = expand-column-to-available-width;

            "Mod+C".action = center-column;
            "Mod+Ctrl+C".action = center-visible-columns;

            "Mod+Minus".action = set-column-width "-10%";
            "Mod+Equal".action = set-column-width "+10%";

            "Mod+Shift+Minus".action = set-window-height "-10%";
            "Mod+Shift+Equal".action = set-window-height "+10%";

            "Mod+V".action = toggle-window-floating;
            "Mod+Shift+V".action = switch-focus-between-floating-and-tiling;

            "Mod+W".action = toggle-column-tabbed-display;
          };

          layout = {
            gaps = 5;
            center-focused-column = "never";
          };

          window-rules = [
            {
              # geometry-corner-radius = 1;
              geometry-corner-radius = let
                r = 4.0;
              in {
                top-left = r;
                top-right = r;
                bottom-left = r;
                bottom-right = r;
              };
              clip-to-geometry = true;
            }

            {
              matches = [{is-focused = false;}];
              opacity = 0.95;
            }

            {
              matches = [{app-id = "waybar";}];
              opacity = 0.7;
            }

            {
              draw-border-with-background = false;
              matches = map (app-id: {inherit app-id;}) [
                "code"
                "kitty"
                "vesktop"
                "org.qbittorrent.qBittorrent"
                "thunar"
                "dolphin"
                "org.gnome.Nautilus"
                "chromium"
                "brave"
                "obsidian"
                "zen"
                "obs-studio"
              ];
              opacity = 0.99;
            }
          ];

          input = {
            mouse = {
              accel-profile = "flat";
            };

            keyboard = {
              numlock = true;
            };

            touchpad = {
              tap = true;
              natural-scroll = true;
            };
          };

          animations.window-resize.custom-shader = ''
            vec4 resize_color(vec3 coords_curr_geo, vec3 size_curr_geo) {
                vec3 coords_next_geo = niri_curr_geo_to_next_geo * coords_curr_geo;

                vec3 coords_stretch = niri_geo_to_tex_next * coords_curr_geo;
                vec3 coords_crop = niri_geo_to_tex_next * coords_next_geo;

                // We can crop if the current window size is smaller than the next window
                // size. One way to tell is by comparing to 1.0 the X and Y scaling
                // coefficients in the current-to-next transformation matrix.
                bool can_crop_by_x = niri_curr_geo_to_next_geo[0][0] <= 1.0;
                bool can_crop_by_y = niri_curr_geo_to_next_geo[1][1] <= 1.0;

                vec3 coords = coords_stretch;
                if (can_crop_by_x)
                    coords.x = coords_crop.x;
                if (can_crop_by_y)
                    coords.y = coords_crop.y;

                vec4 color = texture2D(niri_tex_next, coords.st);

                // However, when we crop, we also want to crop out anything outside the
                // current geometry. This is because the area of the shader is unspecified
                // and usually bigger than the current geometry, so if we don't fill pixels
                // outside with transparency, the texture will leak out.
                //
                // When stretching, this is not an issue because the area outside will
                // correspond to client-side decoration shadows, which are already supposed
                // to be outside.
                if (can_crop_by_x && (coords_curr_geo.x < 0.0 || 1.0 < coords_curr_geo.x))
                    color = vec4(0.0);
                if (can_crop_by_y && (coords_curr_geo.y < 0.0 || 1.0 < coords_curr_geo.y))
                    color = vec4(0.0);

                return color;
            }
          '';
        };
      }
    )
  ]);
}
