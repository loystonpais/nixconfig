# Collection of some useful functions

with builtins; {
  isValidHostName = name: (match "^$|^[[:alnum:]]([[:alnum:]_-]{0,61}[[:alnum:]])?$" name) != null;
}