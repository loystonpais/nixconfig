{ config, lib, pkgs, inputs, ... }: {
  imports = [ inputs.nixvim.nixosModules.nixvim ];

  config = lib.mkIf config.lunar.modules.nixvim.enable {

    programs.nixvim = {
      enable = true;
      colorschemes.gruvbox.enable = true;

      opts = { number = true; };

      plugins = {
        lualine.enable = true;
        lsp.servers.pyright = { enable = true; };
      };
    };
  };
}
