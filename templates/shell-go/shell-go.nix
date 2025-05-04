{pkgs ? import <nixpkgs> {config = {allowUnfree = true;};}}:
with builtins;
with pkgs;
  mkShell rec {
    name = "Go Shell";
    buildInputs = [
      go
      gopls
    ];
    shellHook = ''
      echo -e "\033[32;1;3;5m${name} initialized with packages ${pkgs.lib.concatStringsSep ", " (builtins.map (x: x.name) buildInputs)}\033[0m"
    '';
  }
