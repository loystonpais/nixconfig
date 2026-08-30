{
  den,
  lunar,
  ...
}: {
  den.homes.x86_64-linux."loyston_pais@maple" = {};

  den.aspects.loyston_pais = {
    includes = [
      lunar.dev
    ];
  };
}
