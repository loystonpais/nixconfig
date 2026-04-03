{
  inputs,
  den,
  ...
}: {
  imports = [
    (inputs.den.namespace "lunar" false)
  ];

  config._module.args.__findFile = den.lib.__findFile;
}
