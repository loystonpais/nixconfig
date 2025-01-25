with builtins; {
  # Imports default.nix from dirs within a given path
  # and maps them to their dir name
  importMapFromDir =
    path:
    let
      dirs = let dirs' = readDir path; in mapA
  ;
}