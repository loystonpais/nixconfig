# Profile full
# will contain every single module added to modules folder

{ ... }: 

{
  imports = [
    ../../options/modules/all.nix

    ../../required/all.nix
  ];
}
