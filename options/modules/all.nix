{ ... }: 
with builtins;
{
  imports = map (name: ./. + name) (attrNames (readDir ./.));
}