{
  config,
  lib,
  ...
}: {
  options.lunar.modules.xonsh = {
    enable = lib.mkEnableOption "xonsh";
    home.enable = lib.mkEnableOption "xonsh home-manager";
  };

  config = lib.mkIf config.lunar.modules.xonsh.enable (lib.mkMerge [
    {
      programs.xonsh = {
        enable = true;
        extraPackages = ps:
          with ps; [
            numpy
            xonsh.xontribs.xontrib-vox
            xonsh.xontribs.xonsh-direnv
            # coconut #? Doesn't work because of python verison mismatch
            requests
          ];
      };
    }

    {
      lunar.modules.xonsh.home.enable = lib.mkDefault true;
      home-manager.users.${config.lunar.username}.imports = [
        ./home.nix
        ./external-home-module.nix
      ];
    }
  ]);
}
