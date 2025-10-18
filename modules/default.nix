{
  lib,
  config,
  inputs,
  system,
  ...
}: {
  config = {
    home-manager = {
      backupFileExtension = "nixbak";
      extraSpecialArgs = {
        inherit inputs;
        inherit system;
      };
      sharedModules = [inputs.plasma-manager.homeModules.plasma-manager];
      useGlobalPkgs = true;
      useUserPackages = true;
      users.${config.lunar.username} = {
        imports = [
          ./home.nix
        ];
      };
    };
  };

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
    # ./stylix -- hard to maintain
    ./waybar
    ./plasma
    # ./nvf
    ./bluetooth
    ./vscode
    ./docker
    ./zed
    ./zsh
    ./git
    ./hyprland
    ./program-collection
    ./fonts
    ./xonsh
  ];
}
