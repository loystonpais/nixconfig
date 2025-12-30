{pkgs ? import <nixpkgs> {config = {allowUnfree = true;};}}:
with builtins;
with pkgs;
  mkShell rec {
    name = "Go Shell";
    packges = [
      go
      gopls
    ];
    shellHook = ''
      echo -e "\033[32;1;3;5m${name} initialized with packages ${pkgs.lib.concatStringsSep ", " (builtins.map (x: x.name) packges)}\033[0m"
    '';
  }
