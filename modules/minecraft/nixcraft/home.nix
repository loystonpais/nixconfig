# This config showcases several nixcraft's features (home manager only)
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  speedrunpack-mrpack = pkgs.fetchurl {
    url = "https://cdn.modrinth.com/data/1uJaMUOm/versions/5icZYG8d/SpeedrunPack-mc1.16.1-v6.0.0.mrpack";
    hash = "sha256-5cLBucJTaia7tTytrJrUA5Rou/oyLot1umWq/4o+Fuw=";
  };

  fsgmod-jar = pkgs.fetchurl {
    url = "https://cdn.modrinth.com/data/XZOGBIpM/versions/4IW4nMP3/fsg-mod-5.2.0%2BMC1.16.1.jar";
    hash = "sha256-bA3Y+7OWex8LwEXgMN+7DH6vi6hIoOZ7w3XzA3AE4qg=";
  };

  # A world dir
  mcsr-practice-map = pkgs.fetchzip {
    url = "https://github.com/Dibedy/The-MCSR-Practice-Map/releases/download/1.0.1/MCSR.Practice.v1.0.1.zip";
    stripRoot = false;
    hash = "sha256-ukedZCk6T+KyWqEtFNP1soAQSFSSzsbJKB3mU3kTbqA=";
  };
in {
  imports = [
    # Import the nixcraft home module
    inputs.nixcraft.homeModules.default
    # (builtins.getFlake
    #   "git+file:/home/loystonpais/Shells/nixcraft").outputs.homeModules.default
  ];

  config = {
    nixcraft = {
      server.instances = {};

      enable = true;

      client = {
        # Config to share with all instances
        shared = {
          # Symlink screenshots dir from all instances
          files."screenshots".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Pictures";

          # Common account
          account = {
            username = "loystonlive";
            uuid = "2909ee95-d459-40c4-bcbb-65a0cc413110";
            offline = true;
          };

          # Game is passed to the gpu (set if you have nvidia gpu)
          enableNvidiaOffload = true;

          envVars = {
            # Fixes bug with nvidia
            __GL_THREADED_OPTIMIZATIONS = "0";
          };

          binEntry.enable = true;
        };

        instances = {
          # Example client customized for minecraft speedrunning
          fsg = {
            enable = true;

            preLaunchShellScript = lib.mkBefore ''
              mkdir -p ${lib.escapeShellArg config.nixcraft.client.instances.fsg.absoluteDir}
              rm -rf ${lib.escapeShellArg config.nixcraft.client.instances.fsg.absoluteDir}/saves/*

              echo "Setting niceness..."
              /run/wrappers/bin/sudo ${pkgs.util-linux}/bin/renice --priority -20 -p $$
            '';

            # this advanced option accepts common arguments that are passed to the client
            _classSettings = {
              fullscreen = true;
              # height = 1080;
              # width = 1920;
              uuid = "2909ee95-d459-40c4-bcbb-65a0cc413110";
              username = "loystonlive";
            };
            # version = "1.16.1"; # need not be set (inferred)

            mrpack = {
              enable = true;
              file = speedrunpack-mrpack;
            };

            # Set saves
            saves = {
              "Practice Map" = mcsr-practice-map;
            };

            # place custom files
            files = {
              # mods can also be manually set
              "mods/fsg-mod.jar".source = fsgmod-jar;

              # setting config files
              "config/mcsr/standardsettings.json".source = ./standardsettings.json;
              "options.txt" = {
                source = ./options.txt;
              };
            };

            java = {
              extraArguments = [
                "-XX:+UseZGC"
                "-XX:-ZUncommit"
                "-XX:+AlwaysPreTouch"
                "-Dgraal.TuneInlinerExploration=1"
                "-XX:NmethodSweepActivity=1"
              ];
              # override java package. This mrpack needs java 17
              package = pkgs.graalvmPackages.graalvm-oracle_17;
              # set memory in MBs
              maxMemory = 3500;
              minMemory = 3500;
            };

            envVars.LD_PRELOAD = lib.mkBefore ["${pkgs.jemalloc}/lib/libjemalloc.so"];

            # waywall can be enabled
            waywall.enable = true;

            # Add executable to path
            binEntry = {
              enable = true;
              # Set executable name
              name = "fsg";
            };

            desktopEntry = {
              enable = true;
              name = "Nixcraft FSG";
              extraConfig = {
                # TODO: fix icons not working
                # icon = "${inputs.self}/assets/minecraft/dirt.svg";
                terminal = true;
              };
            };
          };

          rsg = {
            enable = true;

            _classSettings = {
              fullscreen = true;
              uuid = "2909ee95-d459-40c4-bcbb-65a0cc413110";
              username = "loystonlive";
            };

            mrpack = {
              enable = true;
              file = speedrunpack-mrpack;
            };

            # place custom files
            files = {
              # setting config files
              "config/mcsr/standardsettings.json".source = ./standardsettings.json;
              "options.txt" = {
                source = ./options.txt;
              };
            };

            java = {
              extraArguments = [
                "-XX:+UseZGC"
                "-XX:+AlwaysPreTouch"
                "-Dgraal.TuneInlinerExploration=1"
                "-XX:NmethodSweepActivity=1"
              ];
              package = pkgs.jdk17;
              maxMemory = 4000;
              minMemory = 4000;
            };

            waywall.enable = true;

            binEntry = {
              enable = true;
              name = "rsg";
            };

            desktopEntry = {
              enable = true;
              name = "Nixcraft RSG";
              extraConfig = {
                terminal = true;
              };
            };
          };
        };
      };
    };
  };
}
