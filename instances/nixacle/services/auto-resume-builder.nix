{
  lib,
  inputs,
  pkgs,
  config,
  ...
}: {
  services.auto-resume-builder = {
    enable = true;
    envFilePath = config.sops.secrets.auto-resume-builder.path;
  };

  imports = [
    inputs.resumake.nixosModules.default
  ];
}
