{
  den,
  lib,
  inputs,
  lunar,
  ...
}: {
  lunar.hyprland = {
    includes = [
      lunar.hyprland._.fix-webrtc
    ];

    nixos = {pkgs, ...}: {
      programs.hyprland = {
        enable = true;
      };

      environment.systemPackages = with pkgs; [
        ghostty
        alacritty
      ];

      xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [
          kdePackages.xdg-desktop-portal-kde
          xdg-desktop-portal-gtk
          xdg-desktop-portal-gnome
        ];
        config.common.default = "gnome";
        #config.niri."org.freedesktop.impl.portal.FileChooser" = ["kde"];
      };

      systemd.user.services.kded6 = {
        description = "KDE Daemon";
        wantedBy = ["graphical-session.target"];
        partOf = ["graphical-session.target"];
        after = ["graphical-session.target"];
        serviceConfig = {
          ExecStart = "${pkgs.kdePackages.kded}/bin/kded6";
          Restart = "on-failure";
          Slice = "session.slice";
          # FIX: Explicitly pass the prefix so kded6 looks for 'plasma-applications.menu'
          Environment = "XDG_MENU_PREFIX=plasma-";
        };
      };
    };

    homeManager = {
      pkgs,
      config,
      ...
    }: {
      xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-gtk
        ];
      };
    };

    provides.fix-webrtc = {
      homeManager = {pkgs, ...}: {
        xdg.portal = {
          enable = true;
          extraPortals = with pkgs; [
            xdg-desktop-portal-gtk
            xdg-desktop-portal-gnome
          ];
          configPackages = with pkgs; [
            xdg-desktop-portal-gtk
            xdg-desktop-portal-gnome
          ];
        };
      };
    };
  };
}
