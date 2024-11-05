{ lib, inputs, pkgs, config, ... }:

{
  imports = [
    ./vars.nix
  ];


  environment.systemPackages = [

    (pkgs.callPackage (builtins.fetchGit {
      url = "https://github.com/loystonpais/idk-shell-command";
      ref = "main";
      rev = "4090d721d4e2e42e451cb11eae7fba750ab7ca03";
    }) { inherit pkgs; })
 
  ];

  system.stateVersion = "23.11"; # Did you read the comment?

}

