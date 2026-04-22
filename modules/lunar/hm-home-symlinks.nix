{
  den,
  inputs,
  lib,
  ...
}: let
in {
  lunar.hm-home-symlinks = {user, ...}: let
    dir = "${inputs.self.outPath}/hm-home-symlinks/${user.userName}";

    # Recursively collect all files under a user dir as { "rel/path/file" = /abs/path; }
    collectFiles = base: prefix:
      lib.concatMapAttrs (
        name: type: let
          path = "${base}/${name}";
          key =
            if prefix == ""
            then name
            else "${prefix}/${name}";
        in
          if type == "regular"
          then {${key} = path;}
          else if type == "directory"
          then collectFiles path key
          else {}
      ) (builtins.readDir base);
  in {
    homeManager = {config, ...}: {
      home.file = lib.mapAttrs (rel: abs: {source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/hm-home-symlinks/${user.userName}/${rel}";}) (collectFiles dir "");
    };
  };
}
