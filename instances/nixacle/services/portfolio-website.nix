{ inputs, ... }:
{
  imports = [
  	inputs.portfolio-website.nixosModules.default
  ];

  programs.portfolio-website = {
    enable = true;
  };
}
