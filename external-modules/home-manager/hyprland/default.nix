{ config, pkgs, settings, inputs, ... }: 

with builtins;

let 
  startupFile = toFile "start.sh" ''
    #!/usr/bin/env bash
    swww init &
    waybar &  
  '';

in

{

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";
      "$terminal" = "kitty";
      "$fileManager" = "dolphin";

      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,40"
      ];

      "exec-once" = [
        "bash ${startupFile}"
      ];

      general = {
        gaps_in = 5;
        gaps_out = 20;

        resize_on_border = false;
        allow_tearing = false;
        layout = "dwindle";
        
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
      };

      bind = [
        "$mod, X, exec, $terminal"
        "$mod, C, killactive"
        "$mod, S, exec, rofi -show drun -show-icons"
        "$mod, M, exit"
        
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      windowrulev2 = "suppressevent maximize, class:.*";

      gestures = {
        workspace_swipe = false;
      };

      input = {
        kb_layout = "us";
        follow_mouse = 1;
        sensitivity = 0;
      };

      master.new_is_master = true;

      animations.enabled = true;

      decoration.rounding = 10;


    };


  };

}
