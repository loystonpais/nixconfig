{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.lunar.modules.nixvim.enable {
    environment.systemPackages = with pkgs; [
      
    ];
  };
}
