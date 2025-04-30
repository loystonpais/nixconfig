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
        "html"
        "xml"
        "lua"
        "typos"
        "kotlin"
        "csharp"
        "ini"
        "basher"
        "dockerfile"
        "gleam"
        "slint"
        "svelte"
        "dart"
        "flutter-snippets"
        "git-firefly"
        "terraform"
        "zig"
        "gdscript"
        "ruff"
        "haskell"
        "assembly"

        # Themes
        "xcode-themes"
        "vscode-dark-plus"
        "macos-classic"
        "intellij-newui-theme"

        # Icon Themes
        "vscode-icons"
      ];
      # Add formatters
      # Avoid lsps or the language toolset
      # As they should be provided by the dev shell
      # dart zsl haskell-language-server
      extraPackages = [
        pkgs.nixd
        pkgs.nil
        pkgs.rustfmt
      ];
      userSettings = {
        hour_format = "hour12";
        auto_update = false;
        terminal = {
          working_directory = "current_project_directory";
        };
        theme = lib.mkDefault "JetBrains New Dark";
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

        font_family = "FiraCode Nerd Font Mono";
        buffer_font_family = "FiraCode Nerd Font Mono";
        terminal.font_family = "FiraCode Nerd Font Mono";
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

          Python = {
            language_servers = ["ruff"];
            format_on_save = "on";
            formatter = {
              language_server = {
                name = "ruff";
              };

              # Doesn't work for some reason
              /*
              code_actions = {
                "source.organizeImports.ruff" = true;
              };
              */
            };
          };

          /*
            Markdown = {
            formatter = "prettier";
          };
          TOML = {
            formatter = "taplo";
          };
          JSON = {
            formatter = "prettier";
          };
          */

          Zig = {
            format_on_save = "language_server";
            code_actions_on_format = {
              "source.fixAll" = true;
              "source.organizeImports" = true;
            };
          };
        };

        # Setting this makes nix's formatter not work
        /*
          prettier = {
          allowed = true;
        };
        */

        lsp = {
          zls = {
            binary.path_lookup = true;
          };

          dart = {
            binary.path_lookup = true;
            settings = {
              "lineLength" = 140;
            };
          };

          hls = {
            initialization_options = {
              haskell.formattingProvider = "fourmolu";
            };
            binary.path_lookup = true;
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
          };
        };
      };
    };
  };
}
