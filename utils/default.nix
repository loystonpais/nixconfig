with builtins;
{ lib ? (import <nixpkgs> { }).lib }: rec {

  inherit lib;

  forAllSystems = lib.genAttrs lib.systems.flakeExposed;

  importFromDir = path: (importDirsFromDir path) // (importFilesFromDir path);

  filterAttrs = lib.attrsets.filterAttrs;

  filterAttrsByValue = f: attrs: filterAttrs (n: v: f v) attrs;

  filterAttrsByName = f: attrs: filterAttrs (n: v: f n) attrs;

  # Returns attrs whose value is "directory"
  filterDirs = filterAttrsByValue (v: v == "directory");

  # Returns attrs whose value is "regular"
  filterFiles = filterAttrsByValue (v: v == "regular");

  isNixFile = lib.strings.hasSuffix ".nix";

  removeNixSuffix = lib.strings.removeSuffix ".nix";

  isDefaultNixFile = s: s == "default.nix";

  # Like readDir but only returns dirs
  readDir'dirs = path: filterDirs (readDir path);

  # Like readDir but only returns files
  readDir'files = path: filterFiles (readDir path);

  # Like readDir'files but only returns nix files
  readDir'nixFiles = path:
    filterAttrsByName (file: isNixFile file) (readDir'files path);

  # Imports files and directories from a given dir path
  # Some tips:
  # Avoid having directories that end with .nix
  # Avoid having directories and files with same name (excluding the .nix suffix)
  # Avoid defalut.nix files at the root of the dir path
  importDir = { path, includeDirs ? true, includeFiles ? true
    , prioritizeFiles ? true, cleanSource ? true, excludes ? [ ]
    , customPipe ? (attr: attr), excludeDefaultNix ? true, importPaths ? true }:
    let
      dirs = lib.attrsets.optionalAttrs includeDirs readDir'dirs path;
      files = lib.attrsets.optionalAttrs includeFiles readDir'nixFiles path;

      attrs = lib.trivial.pipe (dirs // files) [

        # Remove the files / folders in the exclusion list
        (a: filterAttrsByName (fileName: !(elem fileName excludes)) a)

        # Removes default.nix
        (a:
          if excludeDefaultNix then
            filterAttrsByName (fileName: fileName != "default.nix") a
          else
            a)

        # Clean the source
        (a:
          if cleanSource then
            filterAttrs lib.sources.cleanSourceFilter a
          else
            a)

        # Create paths
        (a: mapAttrs (fileName: value: joinPathAndString path fileName) a)

        # Remove .nix prefix
        (a:
          with lib.attrsets;
          mapAttrs' (n: v: nameValuePair (removeNixSuffix n) v) a)

        (customPipe)

        # Import the paths
        (a: if importPaths then mapAttrs (fileName: path: import path) a else a)
      ];
    in attrs;

  # Shorthand for importDir with default settings
  importDir' = path: importDir { inherit path; };


  # Import templates from the given path
  # Reads README.md file for description
  importTemplates = path:
    importDir {
      inherit path;
      importPaths = false;
      customPipe = (a:
        mapAttrs (n: v: {
          path = v;
          description = readFile (v + "/README.md");
        }) a);
    };

  mkConfigWithEnableOptions' = attr: {
    options = mapAttrs (name: value: { enable = lib.mkEnableOption name; }) (attr);
    imports = lib.attrsets.mapAttrsToList (name: path: f);
  };

  mkConfigWithEnableOption = name: f: inputs: {
    options.${name}.enable = lib.mkEnableOption name;
    config = lib.mkIf config.${name}.enable (f inputs);
  };

  joinPathAndString = path: string: path + "/${string}";

}
