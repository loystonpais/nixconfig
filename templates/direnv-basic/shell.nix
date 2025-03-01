{pkgs ? import <nixpkgs> {config = {allowUnfree = true;};}}:
with pkgs;
  mkShell {
    buildInputs = [];
    shellHook = "cat README.md";
  }
