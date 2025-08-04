{
  lib,
  config,
  ...
}: {
  #imports = map (name: ./. + ( "/" + name)) (attrNames (readDir ./.));

  imports = [
    ./misc
    ./distrobox
    ./gamedev
    ./gaming
    ./minecraft
    ./multimedia
    ./piracy
    ./samba
    ./virtual-machine
    ./waydroid
    ./browsers
    ./android
    ./ssh
    ./secrets
    ./hardware
    ./audio
    ./graphics
    ./vpn
    ./rclone
    ./niri
    ./stylix
    ./waybar
    ./plasma
    ./nvf
    ./bluetooth

    ./home-manager
  ];
}
