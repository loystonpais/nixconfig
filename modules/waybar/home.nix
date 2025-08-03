{
  osConfig,
  config,
  lib,
  ...
}: {
  config = lib.mkIf osConfig.lunar.modules.waybar.enable (lib.mkMerge [
    ( # Waybar
      {
        programs.waybar.enable = true;
        programs.waybar.systemd.enable = lib.mkDefault true;
        programs.waybar.settings = {
          mainBar = {
            layer = "top";
            position = "top";
            height = 30;
            output = [
              "eDP-1"
              "HDMI-A-1"
            ];
            modules-left = [
              "niri/workspaces"
              "custon/sep"
              "disk"
              "cpu"
              "memory"
              "custom/sep"
              "niri/window"
              "custom/sep"
              "wlr/taskbar"
            ];
            modules-center = ["clock"];
            modules-right = [
              "group/info"
              "custom/sep"
              "mpris"
              "network"
              "custom/sep"
              "backlight"
              "custom/sep"
              "wireplumber"
              "custom/sep"
              "battery"
            ];

            backlight = {
              device = "acpi_video0";
              format = "{icon} {percent}%";
              format-icons = [
                "🔅"
                "🔆"
                "☀️"
              ];
              on-click = "brightnessctl set +10%";
              on-click-right = "brightnessctl set 10%-";
              tooltip-format = "Brightness: {percent}%";
            };

            mpris = {
              dynamic-len = 40;
              dynamic-order = [
                "title"
                "artist"
              ];
              format = "  {status_icon} {dynamic}";
              ignored-players = ["firefox"];
              interval = 1;
              status-icons = {
                paused = "⏸";
                playing = "▶";
                stopped = "";
              };
            };

            battery = {
              format = "{icon} {capacity}%";
              format-charging = " {capacity}%";
              format-icons = [
                ""
                ""
                ""
                ""
                ""
              ];
              format-time = "{H}h {M}min left";
              interval = 60;
              states = {
                critical = 10;
                warning = 20;
              };
              tooltip-format = "{capacity}% {time}";
              tooltip-format-charging = "  Charging: {capacity}%";
            };

            clock = {
              calendar = {
                actions = {
                  on-click-right = "mode";
                  on-scroll-down = "shift_down";
                  on-scroll-up = "shift_up";
                };
                format = {
                  days = "<span color='#DCD7BA'><b>{}</b></span>";
                  months = "<span color='#DCD7BA'><b>{}</b></span>";
                  today = "<span color='#236b84'><b><u>{}</u></b></span>";
                  weekdays = "<span color='#ffcc66'><b>{}</b></span>";
                  weeks = "";
                };
                mode = "month";
                mode-mon-col = 3;
                on-scroll = 1;
                weeks-pos = "right";
              };
              format = "{:%I:%M:%S %p  •  %d / %m - %B / %Y}";
              tooltip = true;
              tooltip-format = "{:%A, %d %B %Y}";
              interval = 1;
            };

            cpu = {format = "  {usage}%";};

            "custom/power" = {
              format = "  ";
              on-click = "halt";
              tooltip = false;
            };

            "custom/reboot" = {
              format = " 󰜉 ";
              on-click = "reboot";
              tooltip = false;
            };

            "custom/sep" = {
              format = "|";
              tooltip = false;
            };

            disk = {
              format = " {percentage_free}%";
              interval = 30;
            };

            "niri/workspaces" = {
              format = "{icon}";
              format-icons = {
                active = "";
                default = "";
              };
              persistent-workspaces = {"*" = 5;};
            };

            wireplumber = {
              format = "{icon} {volume}%";
              format-icons = [
                ""
                ""
                ""
              ];
              format-muted = "";
              on-click = "pwvucontrol";
              tooltip-format = "Volume: {volume}%";
            };

            "custom/swaync_notifications" = lib.mkIf (config.services.swaync.enable) {
              escape = true;
              exec = "swaync-client -swb";
              exec-if = "which swaync-client";
              format = "{icon}";
              format-icons = {
                dnd-inhibited-none = "󰂛";
                dnd-inhibited-notification = "󰂛";
                dnd-none = "󰂛";
                dnd-notification = "󰂛";
                inhibited-none = "󰂚";
                inhibited-notification = "󰂚";
                none = "󰂚";
                notification = "󱅫";
              };
              on-click = "swaync-client -t -sw";
              on-click-right = "swaync-client -d -sw";
              return-type = "json";
              tooltip = false;
            };

            "group/info" = {
              modules = [
                "tray"
                "custom/notifications"
              ];
              orientation = "inherit";
            };

            tray = {
              icon-size = 13;
              spacing = 5;
            };

            network = {
              interface = "wlo0";
              family = "ipv4_6";
              interval = 2;
              format = "{ifname}";
              format-wifi = "{essid} ({signalStrength}%) ";
              format-ethernet = "{ipaddr}/{cidr} 󰊗";
              format-disconnected = "Disconnected ⚠";
              tooltip-format = "{ifname} via {gwaddr}";
              tooltip-format-wifi = "{essid} ({signalStrength}%) ";
              tooltip-format-ethernet = "{ifname} ";
              tooltip-format-disconnected = "Disconnected";
              max-length = 50;
              # on-click = "nm-applet";
            };
          };
        };
        programs.waybar.style = ''
          * {
            border: none;
            border-radius: 0;
          }
          #workspaces button {
            padding: 0 5px;
          }
        '';
      }
    )
  ]);
}
