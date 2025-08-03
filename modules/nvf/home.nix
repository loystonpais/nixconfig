{
  osConfig,
  config,
  inputs,
  lib,
  ...
}: {
  imports = [
    inputs.nvf.homeManagerModules.default
  ];

  config = lib.mkIf osConfig.lunar.modules.nvf.enable (lib.mkMerge [
    {
      programs.nvf = {
        enable = true;
        settings = {
          vim = {
            lsp = {
              enable = true;
            };
            vimAlias = true;
            statusline.lualine.enable = true;
            telescope.enable = true;
            autocomplete.nvim-cmp.enable = true;
            languages = {
              enableTreesitter = true;
              nix = {
                enable = true;
              };
              rust.enable = true;
              python.enable = true;
              zig.enable = true;
              html.enable = true;
              go.enable = true;
              lua.enable = true;
            };
          };
        };
      };
    }
  ]);
}
