{
  prismlauncher,
  callPackage,
  ...
}:
prismlauncher.override {prismlauncher-unwrapped = callPackage ./prismlauncher-unwrapped-crack.nix {};}
