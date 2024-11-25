{ systemConfig, lib, pkgs, ... }: 
{
  config = lib.mkIf systemConfig.vars.modules.home-manager.fonts.enable {
    fonts.fontconfig.enable = true;

    home.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      nerdfonts
      fira-code
      fira-code-symbols 

    ];
  };
}