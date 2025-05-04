{pkgs ? import <nixpkgs> {config = {allowUnfree = true;};}} @ args:
with builtins;
with pkgs;
  mkShell rec {
    name = "Main Shell";
    inputsFrom =
      (map (p: import p args) (filter pathExists [
        # Add (optional) shells to merge
        ./shell-go.nix
        ./shell-python.nix
        ./shell-rust.nix
        ./shell-ruby.nix
        ./shell-node.nix
      ]))
      ++ [
        # Add shells to merge
      ];

    buildInputs = [
      # Add your custom build inputs here
      hello
    ];
    shellHook = ''
      # Add your custom shell hook commands here

      # Initialize environment variables
      # export MY_ENV_VAR="my_value"

      echo -e "\033[34;1;3;5m${name} initialized with packages ${pkgs.lib.concatStringsSep ", " (builtins.map (x: x.name) buildInputs)}\033[0m"
    '';
  }
