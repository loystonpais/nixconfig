with builtins;
{ config, lib, pkgs, inputs, vars, ... }:

{
  imports = [

    ./hardware-configuration.nix

    ../../nixos-profiles/full

    ../../options/graphics/asuslinux.nix

    # Home manager
    inputs.home-manager.nixosModules.home-manager
  ];

 # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  # Enabling zsh, will put it in required later
  programs.zsh.enable = true;


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${vars.username} = {
    isNormalUser = true;
    description = "Userspace of " + vars.name;
    extraGroups = [ "networkmanager" "wheel" "disk" ];
    shell = pkgs.zsh;
    packages = [ ];
  };

  # Allow unfree packages
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };


  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
      inherit vars;
    };
    users.${vars.username} = import ../../external-modules/home-manager;
    useGlobalPkgs = true;
  };

  system.stateVersion = "23.11"; # Did you read the comment?

  nix.vars.experimental-features = [ "nix-command" "flakes" ];
}

