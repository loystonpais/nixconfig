{
  systemConfig,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf (systemConfig.lunar.modules.home-manager.zed.enable) {
    programs.zed-editor = {
      enable = true;
      extensions = [
        "nix"
        "toml"
        "basher"
        "gleam"
        "slint"
        "svelte"
        "dart"
        "flutter-snippets"
        "git-firefly"
        "xcode-themes"
      ];
      extraPackages = [
        pkgs.nixd
        pkgs.nil
        pkgs.dart
        pkgs.rustfmt
      ];
      userSettings = {
        hour_format = "hour12";
        auto_update = false;
        terminal = {
          working_directory = "current_project_directory";
        };
        theme = lib.mkForce "Gruvbox Dark";
        load_direnv = "shell_hook";
        base_keymap = "VSCode";
        show_whitespaces = "all";
        ui_font_size = lib.mkForce 14;
        buffer_font_size = lib.mkForce 14;
        indent_guides = {
          enabled = true;
          coloring = "indent_aware";
        };
        inlay_hints.enabled = true;
        inactive_opacity = "0.5";
        auto_install_extensions = true;

        # Panels
        outline_panel.dock = "right";
        project_panel.dock = "right";

        font_family = "FiraCode Nerd Font";
        format_on_save = "on";

        node = {
          path = lib.getExe pkgs.nodejs;
          npm_path = lib.getExe' pkgs.nodejs "npm";
        };

        languages = {
          Nix = {
            language_servers = [
              "nil"
              "!nixd"
            ];
            formatter = {
              external = {
                command = lib.getExe pkgs.alejandra;
              };
            };
          };
        };

        lsp = {
          dart = {
            path_lookup = true;
          };

          rust-analyzer = {
            binary = {
              #path = lib.getExe pkgs.rust-analyzer;
              path_lookup = true;
            };
            settings = {
              diagnostics = {
                enable = true;
                styleLints = {
                  enable = true;
                }; # Corrected styleLints access
              };
              checkOnSave = true;
              check = {
                command = "clippy";
                features = "all";
              };
              cargo = {
                buildScripts = {
                  enable = true;
                }; # Corrected buildScripts access
                features = "all";
              };
              inlayHints = {
                bindingModeHints = {
                  enable = true;
                }; # Corrected access
                closureStyle = "rust_analyzer";
                closureReturnTypeHints = {
                  enable = "always";
                }; # Corrected access
                discriminantHints = {
                  enable = "always";
                }; # Corrected access
                expressionAdjustmentHints = {
                  enable = "always";
                }; # Corrected access
                implicitDrops = {
                  enable = true;
                };
                lifetimeElisionHints = {
                  enable = "always";
                }; # Corrected access
                rangeExclusiveHints = {
                  enable = true;
                };
              };
              procMacro = {
                enable = true;
              };
              rustc = {
                source = "discover";
              };
              files = {
                excludeDirs = [
                  ".cargo"
                  ".direnv"
                  ".git"
                  "node_modules"
                  "target"
                ];
              };
            };
            /*
            using languages.Nix instead
              nix = {
              binary = {path_lookup = true;};
            };
            nil = {
              initialization_options.formatting.command = [(lib.getExe pkgs.alejandra) "--quiet" "--"];
              };
            */
          };
        };
      };
    };
  };
}
