with builtins; {
  listDir = path: attrNames (readDir path)
  fromDir = dirName: fun
}