{
  osConfig,
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  nix-vscode-extensions = inputs.nix-vscode-extensions;
in {
  config = lib.mkIf osConfig.lunar.modules.vscode.enable (lib.mkMerge [
    {
      programs.vscode = {
        enable = true;

        mutableExtensionsDir = false;

        profiles = {
          default = {
            userSettings = {
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

              "editor.fontFamily" = lib.mkIf osConfig.lunar.modules.stylix.enable osConfig.stylix.fonts.monospace.name;
              "editor.formatOnSave" = true;
              "editor.wordWrap" = "on";
              "editor.wordWrapColumn" = 120;
              "editor.fontLigatures" = true;
              "editor.tabSize" = 2;
            };

            extensions = with pkgs.vscode-marketplace; [
              # Nix
              bbenoist.nix
              # brettm12345.nixfmt-vscode
              jnoortheen.nix-ide
              jeff-hykin.better-nix-syntax
              kamadorueda.alejandra
              #?? perkovec.nix-extension-pack

              # Rust
              rust-lang.rust-analyzer
              tamasfe.even-better-toml
              dustypomerleau.rust-syntax

              # Golang
              golang.go

              # Gleam
              gleam.gleam

              # Nushell
              thenuprojectcontributors.vscode-nushell-lang

              # Dart/Flutter
              dart-code.dart-code
              dart-code.flutter
              nash.awesome-flutter-snippets

              # Python
              ms-python.python
              ms-python.vscode-pylance
              ms-python.debugpy
              ms-python.mypy-type-checker
              magicstack.magicpython

              # Markdown
              yzhang.markdown-all-in-one
              shd101wyy.markdown-preview-enhanced
              davidanson.vscode-markdownlint
              myml.vscode-markdown-plantuml-preview
              unifiedjs.vscode-mdx

              # Haskell
              haskell.haskell

              # XML/YAML/Config
              redhat.vscode-yaml
              redhat.vscode-xml

              # JavaScript/TypeScript
              dbaeumer.vscode-eslint
              yoavbls.pretty-ts-errors

              # Web Development
              shopify.ruby-lsp
              styled-components.vscode-styled-components
              svelte.svelte-vscode
              ms-vscode.live-server
              #?? pulkitgangwar.liveserver
              dsznajder.es7-react-js-snippets
              pulkitgangwar.nextjs-snippets
              wix.vscode-import-cost
              vincaslt.highlight-matching-tag
              formulahendry.auto-close-tag
              formulahendry.auto-rename-tag
              george-alisson.html-preview-vscode

              # DevOps
              hashicorp.terraform
              ms-azuretools.vscode-docker
              github.vscode-github-actions
              github.vscode-pull-request-github
              gitlab.gitlab-workflow

              # Git
              eamodio.gitlens
              mhutchie.git-graph
              vivaxy.vscode-conventional-commits
              donjayamanne.githistory

              # CSV/Data
              mechatroner.rainbow-csv

              # Icons/Themes
              pkief.material-icon-theme
              vscode-icons-team.vscode-icons

              # Formatters
              esbenp.prettier-vscode

              # Direnv/Nix-shell
              mkhl.direnv

              # C/C++
              llvm-vs-code-extensions.vscode-clangd

              # Miscellaneous
              aaron-bond.better-comments

              editorconfig.editorconfig
              oderwat.indent-rainbow
              jebbs.plantuml
              mushan.vscode-paste-image
              shardulm94.trailing-spaces
              tomoki1207.pdf
              # lucono.karma-test-explorer
              graphql.vscode-graphql
              wushuaibuaa.autocomplete-english-word
              shopify.ruby-extensions-pack
              kisstkondoros.vscode-gutter-preview
              legale.dts-formatter
              # vadimcn.vscode-lldb
              wholroyd.jinja
              jmkrivocapich.drawfolderstructure

              ms-vscode-remote.remote-ssh

              # ms-dotnettools.vscode-dotnet-runtime # install from nixpkgs
              # ms-dotnettools.csdevkit
              # neikeq.godot-csharp-vscode # causes huge rebuild
              # ms-dotnettools.csharp # causes huge rebuild
              # ms-vscode.mono-debug
            ];
          };
        };
      };
    }

    # Configuation For Godot
    {
      programs.vscode = {
        profiles.default.userSettings = {
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
              "path" = "${pkgs.dotnet-sdk_8}/bin/dotnet"; # Godot-Mono uses DotNet8 version.
            }
          ];
          "godotTools.lsp.serverPort" = 6005;
          "omnisharp" = {
            # OminiSharp is a custom LSP for C#
            "path" = "${pkgs.omnisharp-roslyn}/bin/OmniSharp";
            "sdkPath" = "${pkgs.dotnet-sdk_9}";
            "dotnetPath" = "${pkgs.dotnet-sdk_9}/bin/dotnet";
          };
        };
        extensions = with pkgs.vscode-extensions; [
          geequlim.godot-tools # For Godot GDScript support
          woberg.godot-dotnet-tools # For Godot C# support
          ms-dotnettools.csdevkit
          ms-dotnettools.csharp
          ms-dotnettools.vscode-dotnet-runtime
        ];
      };

      home.packages = [
        pkgs.dotnetCorePackages.dotnet_9.sdk # For Godot-Mono VSCode-Extension CSharp
      ];
    }
  ]);
}
