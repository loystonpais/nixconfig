{
  inputs,
  lib,
  den,
  ...
}: {
  imports = [
    inputs.den.flakeOutputs.packages
    inputs.den.flakeOutputs.homeConfigurations
  ];

  den.schema.flake-system.includes.into.host = {system}:
    map (host: {inherit host;})
    (lib.attrValues (den.hosts.${system} or {}));
}
