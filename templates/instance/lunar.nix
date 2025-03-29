{...}: {
  lunar.hostName = "<hostname>";
  lunar.graphicsMode = "none";
  lunar.bootMode = "uefi";

  lunar.sshPublicKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHtN04FVSVonasScikFfltCPFJkSWa3t3z+wo+JA8GGd loyston500@gmail.com"
  ];

  # Enabling plasma
  lunar.modules.desktop-environments.plasma.enable = true;

  # Enabling secrets
  lunar.modules.secrets.enable = true;

  # Enabling ssh
  lunar.modules.ssh.enable = true;

  # Enable home manager with all modules
  lunar.modules.home-manager = {
    enable = true;
    enableAllModules = true;
  };

  # Enable everything
  # lunar.profile.everything.enable = true;

  # Enable if vm
  # lunar.profile.vm.enable = true;
}
