{
  den,
  inputs,
  ...
}: {
  lunar.vscode = {
    nixos = {pkgs, ...}: {
      environment.systemPackages = [pkgs.vscode];

      # adds vscode extensions from marketplace
      nixpkgs.overlays = [
        inputs.nix-vscode-extensions.overlays.default
      ];
    };

    homeManager = {
      pkgs,
      lib,
      osConfig,
      ...
    }: let
      # Common settings shared across all profiles
      commonSettings = {
        "update.mode" = "none";
        "continue.telemetryEnabled" = false;
        "diffEditor.ignoreTrimWhitespace" = false;
        "extensions.autoUpdate" = false;
        "explorer.confirmDragAndDrop" = false;
        "git.enableSmartCommit" = true;
        "redhat.telemetry.enabled" = false;
        "security.workspace.trust.untrustedFiles" = "open";
        "telemetry.enableCrashReporter" = false;
        "telemetry.enableTelemetry" = false;
        "telemetry.telemetryLevel" = "off";
        "workbench.sideBar.location" = "right";
        "terminal.integrated.copyOnSelection" = true;
        "terminal.integrated.cursorBlinking" = true;
        "terminal.integrated.cursorStyle" = "line";
        "terminal.integrated.persistentSessionScrollback" = 1000;
        "terminal.integrated.ignoreBracketedPasteMode" = false;
        "terminal.integrated.rightClickBehavior" = "paste";
        "terminal.integrated.scrollback" = 3000;
        "window.closeOnFileDelete" = true;
        "workbench.colorTheme" = "Dark Modern";
        "workbench.iconTheme" = "vscode-icons";
        "workbench.preferredDarkColorTheme" = "Dark Modern";
        "workbench.statusBar.visible" = true;
        "editor.formatOnSave" = true;
        "editor.wordWrap" = "on";
        "editor.wordWrapColumn" = 120;
        "editor.fontLigatures" = true;
        "editor.tabSize" = 2;

        # Core Nix support (important for this repo)
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = lib.getExe pkgs.nixd;
        "nix.formatterPath" = lib.getExe pkgs.alejandra;
      };

      # Common extensions shared across all profiles
      commonExtensions =
        (with pkgs.vscode-extensions; [
          # Essential Nix support
          bbenoist.nix
          jnoortheen.nix-ide
          kamadorueda.alejandra
          jeff-hykin.better-nix-syntax

          # Essential workflow
          mkhl.direnv
          ms-vscode-remote.remote-ssh
          christian-kohler.path-intellisense
        ])
        ++ (with pkgs.vscode-marketplace; [
          # Essential UI/UX
          pkief.material-icon-theme
          eamodio.gitlens
          mhutchie.git-graph
          vivaxy.vscode-conventional-commits
          aaron-bond.better-comments
          editorconfig.editorconfig
          oderwat.indent-rainbow
          shardulm94.trailing-spaces
          kisstkondoros.vscode-gutter-preview
        ]);
    in {
      config = {
        programs.vscode = {
          enable = true;
          mutableExtensionsDir = false;

          profiles = {
            # 1. Default Profile: Core configuration + Essential Nix
            default = {
              userSettings = commonSettings;
              extensions = commonExtensions;
            };

            # 2. Nix & Shell Dev Profile
            nix-dev = {
              userSettings =
                commonSettings
                // {
                  "nix.enableLanguageServer" = true;
                };
              extensions =
                commonExtensions
                ++ (with pkgs.vscode-marketplace; [
                  jnoortheen.xonsh
                  thenuprojectcontributors.vscode-nushell-lang
                ]);
            };

            # 3. Web & Frontend Dev Profile
            web-dev = {
              userSettings = commonSettings;
              extensions =
                commonExtensions
                ++ (with pkgs.vscode-marketplace; [
                  # JS/TS
                  dbaeumer.vscode-eslint
                  yoavbls.pretty-ts-errors
                  esbenp.prettier-vscode

                  # React / Next.js
                  dsznajder.es7-react-js-snippets
                  pulkitgangwar.nextjs-snippets

                  # Styles
                  styled-components.vscode-styled-components
                  vincaslt.highlight-matching-tag
                  formulahendry.auto-close-tag
                  formulahendry.auto-rename-tag

                  # Frameworks
                  svelte.svelte-vscode
                  shopify.ruby-lsp
                  shopify.ruby-extensions-pack

                  # Web Tools
                  ms-vscode.live-server
                  wix.vscode-import-cost

                  # Docs
                  yzhang.markdown-all-in-one
                  davidanson.vscode-markdownlint
                  unifiedjs.vscode-mdx
                ]);
            };

            # 4. Data Science & Python Profile
            data-dev = {
              userSettings =
                commonSettings
                // {
                  "python.analysis.typeCheckingMode" = "standard";
                  "pylsp.executable" = lib.getExe pkgs.python3Packages.python-lsp-server;
                };
              extensions =
                commonExtensions
                ++ (with pkgs.vscode-extensions; [
                  ms-toolsai.jupyter
                  charliermarsh.ruff
                  ms-python.python
                  ms-python.vscode-pylance
                ])
                ++ (with pkgs.vscode-marketplace; [
                  mechatroner.rainbow-csv
                ]);
            };

            # 5. Systems & Backend Dev Profile
            sys-dev = {
              userSettings = commonSettings;
              extensions =
                commonExtensions
                ++ (with pkgs.vscode-extensions; [
                  elixir-lsp.vscode-elixir-ls
                ])
                ++ (with pkgs.vscode-marketplace; [
                  # Rust
                  rust-lang.rust-analyzer
                  tamasfe.even-better-toml

                  # Go
                  golang.go

                  # Gleam
                  gleam.gleam

                  # Haskell
                  haskell.haskell

                  # C/C++
                  llvm-vs-code-extensions.vscode-clangd
                  ms-vscode.makefile-tools

                  # Others
                  kdl-org.kdl
                  legale.dts-formatter
                ]);
            };

            # 6. DevOps & Infrastructure Profile
            devops = {
              userSettings = commonSettings;
              extensions =
                commonExtensions
                ++ (with pkgs.vscode-marketplace; [
                  hashicorp.terraform
                  ms-azuretools.vscode-containers
                  ms-vscode-remote.remote-containers
                  github.vscode-github-actions
                  github.vscode-pull-request-github
                  gitlab.gitlab-workflow
                  redhat.vscode-yaml
                  redhat.vscode-xml
                ]);
            };

            # 7. Mobile Development Profile
            mobile-dev = {
              userSettings = commonSettings;
              extensions =
                commonExtensions
                ++ (with pkgs.vscode-marketplace; [
                  dart-code.dart-code
                  dart-code.flutter
                  nash.awesome-flutter-snippets
                ]);
            };

            # 8. Godot & C# Profile
            godot-csharp = {
              userSettings =
                commonSettings
                // {
                  "csharp.toolsDotnetPath" = "${pkgs.dotnet-sdk_9}/bin/dotnet";
                  "dotnetAcquisitionExtension.sharedExistingDotnetPath" = "${pkgs.dotnet-sdk_9}/bin/dotnet";
                  "dotnetAcquisitionExtension.existingDotnetPath" = [
                    {
                      "extensionId" = "ms-dotnettools.csharp";
                      "path" = "${pkgs.dotnet-sdk_9}/bin/dotnet";
                    }
                    {
                      "extensionId" = "ms-dotnettools.csdevkit";
                      "path" = "${pkgs.dotnet-sdk_9}/bin/dotnet";
                    }
                    {
                      "extensionId" = "woberg.godot-dotnet-tools";
                      "path" = "${pkgs.dotnet-sdk_8}/bin/dotnet";
                    }
                  ];
                  "godotTools.lsp.serverPort" = 6005;
                  "omnisharp" = {
                    "path" = "${pkgs.omnisharp-roslyn}/bin/OmniSharp";
                    "sdkPath" = "${pkgs.dotnet-sdk_9}";
                    "dotnetPath" = "${pkgs.dotnet-sdk_9}/bin/dotnet";
                  };
                };
              extensions =
                commonExtensions
                ++ (with pkgs.vscode-extensions; [
                  geequlim.godot-tools
                  woberg.godot-dotnet-tools
                  ms-dotnettools.csdevkit
                  ms-dotnettools.csharp
                  ms-dotnettools.vscode-dotnet-runtime
                ]);
            };
          };
        };

        home.packages = [
          pkgs.dotnetCorePackages.dotnet_9.sdk
        ];
      };
    };
  };
}
