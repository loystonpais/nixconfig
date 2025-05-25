{inputs, ...}: {
  imports = [
    inputs.portfolio-website.nixosModules.default
  ];

  services.portfolio-website = {
    enable = true;
  };
}
