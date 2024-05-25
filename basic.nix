with builtins;
{ config, lib, pkgs, inputs, settings, ... }:

{
  imports = [

    # Imports required modules
    ./required


    # Home manager
    inputs.home-manager.nixosModules.home-manager

    # Stylix
    #inputs.stylix.nixosModules.stylix
    #(trace "Stylix settings imported" ./modules/stylix)

    # NUR
    #inputs.nur.nixosModules.nur


  ] ++ (if settings.graphicsSetting == "nvidia" then
    trace "Graphics mode nvidia" [ ./options/graphics/nvidia.nix ]
    else if settings.graphicsSetting == "asuslinux" then
    trace "Graphics mode asuslinux" [ ./options/graphics/asuslinux.nix ]
    else abort "Bad graphics setting")

    ++ (if settings.biosBoot then
      trace "Set to bios mode" [ ./options/boot/bios.nix ]
    else
      [ ])

    ++ settings.optionalModules
      ;

 # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };



  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${settings.username} = {
    isNormalUser = true;
    description = "Userspace of " + settings.name;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = [ ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;


  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
      inherit settings;
    };
    users.${settings.username} = import ./external-modules/home-manager;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}

