{
  imports =
    let
      dir = builtins.readDir ./.;
      toImport = name: type:
        if type == "regular" && name != "default.nix" && builtins.hasSuffix ".nix" name
        then ./${name}
        else null;
    in
      builtins.filter (x: x != null) (builtins.attrValues (builtins.mapAttrs toImport dir));
}
