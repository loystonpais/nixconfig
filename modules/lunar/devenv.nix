{
  den,
  inputs,
  ...
}: {
  lunar.devenv = {
    nixos = {
      pkgs,
      lib,
      ...
    }: {
      environment.systemPackages = [
        pkgs.devenv
        (pkgs.writeShellScriptBin "devenv-sync-lunar-nixpkgs" ''
          ${lib.getExe pkgs.yq-go} -i ".inputs.nixpkgs.url = \"github:NixOS/nixpkgs/${inputs.nixpkgs.rev}\"" devenv.yaml
        '')
      ];

      programs.zsh.shellInit = ''
        eval "$(devenv hook zsh)"
      '';

      programs.bash.shellInit = ''
        eval "$(devenv hook bash)"
      '';

      programs.fish.shellInit = ''
        devenv hook fish | source
      '';
    };
  };
}
