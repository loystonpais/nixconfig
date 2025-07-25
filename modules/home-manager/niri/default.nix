{
  systemConfig,
  lib,
  pkgs,
  inputs,
  config,
  ...
}: {
  imports = [
    # inputs.niri-flake.homeModules.niri
  ];

  options = {
    lunar.niri = {
      enable = lib.mkEnableOption "niri home configuration";
    };
  };

  config = lib.mkIf config.lunar.niri.enable (lib.mkMerge [
    ( # Waybar
      {
        programs.waybar.enable = true;
        programs.waybar.settings = {
          mainBar = {
            layer = "top";
            position = "top";
            height = 30;
            output = [
              "eDP-1"
              "HDMI-A-1"
            ];
            modules-left = ["sway/workspaces" "sway/mode" "wlr/taskbar"];
            modules-center = ["sway/window" "custom/hello-from-waybar"];
            modules-right = ["mpd" "custom/mymodule#with-css-id" "temperature"];

            "sway/workspaces" = {
              disable-scroll = true;
              all-outputs = true;
            };
            "custom/hello-from-waybar" = {
              format = "hello {}";
              max-length = 40;
              interval = "once";
              exec = pkgs.writeShellScript "hello-from-waybar" ''
                echo "from within waybar"
              '';
            };
          };
        };
        programs.waybar.style = ''
          * {
            border: none;
            border-radius: 0;
            font-family: Source Code Pro;
          }
          window#waybar {
            background: #16191C;
            color: #AAB2BF;
          }
          #workspaces button {
            padding: 0 5px;
          }
        '';
      }
    )
  ]);
}
