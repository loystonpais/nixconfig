{
  inputs,
  lib,
  den,
  ...
}: {
  imports = [inputs.den.flakeOutputs.packages];

  den.ctx.flake-system.into.host = {system}:
    map (host: {inherit host;})
    (lib.attrValues den.hosts.${system});
}
