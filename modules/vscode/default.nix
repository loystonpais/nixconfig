{
  config,
  lib,
  inputs,
  ...
}: {
  options.lunar.modules.vscode = {
    enable = lib.mkEnableOption "vscode";
    home.enable = lib.mkEnableOption "vscode home-manager";
  };

  config = lib.mkIf config.lunar.modules.vscode.enable (lib.mkMerge [
    {
      # adds vscode extensions from marketplace
      nixpkgs.overlays = [
        inputs.nix-vscode-extensions.overlays.default
      ];
    }

    {
      lunar.modules.vscode.home.enable = lib.mkDefault true;
      home-manager.users.${config.lunar.username}.imports = [
        ./home.nix
      ];
    }
  ]);
}
