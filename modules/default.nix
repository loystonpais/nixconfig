{
  lib,
  config,
  ...
}: {
  #imports = map (name: ./. + ( "/" + name)) (attrNames (readDir ./.));

  imports = [
    ./desktop-environments
    ./program-collection
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
    ./nixvim

    ./home-manager
  ];
}
