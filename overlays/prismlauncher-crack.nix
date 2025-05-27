final: prev: {
  prismlauncher-unwrapped = prev.callPackage ../packages/prismlauncher-unwrapped-crack.nix {};
  prismlauncher = prev.callPackage ../packages/prismlauncher-crack.nix {};
}
