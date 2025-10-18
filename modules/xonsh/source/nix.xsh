
class shell:
    __xonsh_block__ = str

    def __init__(self, enter: bool = True, exitprint: bool = True):
      self.enter = enter
      self.exitprint = exitprint

    def __enter__(self):
        self.source = (
"""{pkgs ? import <nixpkgs> { config = { allowUnfree = true; }; }}:
with pkgs;
with pkgs.lib;
with builtins;
  mkShell {
    %s
}""") % self.macro_block.strip()

        if self.enter:
          self.enter_shell()

        return self

    def enter_shell(self):
      nix shell --impure --expr @(self.source)

    def enter_old_shell(self):
      nix-shell --impure -E @(self.source)

    def __exit__(self, *exc):
        del self.macro_globals, self.macro_locals
        if self.exitprint:
            print(self.source)

    def __repr__(self):
        return self.source