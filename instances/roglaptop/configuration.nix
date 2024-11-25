{ lib, inputs, pkgs, config, ... }:

{
  imports = [
    ./vars.nix
  ];


  environment.systemPackages = [

    (pkgs.callPackage (builtins.fetchGit {
      url = "https://github.com/loystonpais/idk-shell-command";
      ref = "main";
      rev = "de31d1683248722170dfab6b9db9d4dbb44504e0";
    }) { inherit pkgs; })

    pkgs.warp-terminal
  ];

  system.stateVersion = "23.11"; # Did you read the comment?

}

