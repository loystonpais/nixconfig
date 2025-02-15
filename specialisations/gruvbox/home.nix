{ inputs, lib, ... }: {
  stylix.targets = {
    # Plasma theming is very buggy. Disabled
    kde.enable = lib.mkForce false;
  };
}
