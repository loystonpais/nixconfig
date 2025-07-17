{
  config,
  lib,
  pkgs,
  inputs,
  system,
  ...
}: {
  options = {
    lunar = {
      modules.minecraft = {
        enable = lib.mkEnableOption "minecraft";
        cracked = (lib.mkEnableOption "cracked launchers (prismlauncher)") // {default = true;};
      };
    };
  };

  config = lib.mkIf config.lunar.modules.minecraft.enable (lib.mkMerge [
    {
      lunar.modules.minecraft.cracked = true;
      environment.systemPackages = with pkgs; [
        # Accessible from /run/current-system/sw/share/java-collection/
        # Example: /run/current-system/sw/share/java-collection/jdk17/bin/java
        (pkgs.linkFarm "java-collection" [
          {
            name = "share/java-collection/jdk17";
            path = pkgs.jdk17;
          }

          {
            name = "share/java-collection/jdk21";
            path = pkgs.jdk21;
          }
        ])

        prismlauncher
        jdk21
        inputs.self.packages.${system}.ninjabrainbot
        inputs.self.packages.${system}.zig-seed-glitchless

        (pkgs.writers.writePython3Bin "minecraft-delete-saves" {
            libraries = [];
            flakeIgnore = ["E501" "W504" "E123" "E121" "W503"];
          } ''
            import sys
            from shutil import rmtree
            from pathlib import Path
            import subprocess


            zenity = "${pkgs.zenity}/bin/zenity"
            notifysend = "${pkgs.libnotify}/bin/notify-send"


            def is_mc_world_dir(path):
                path = Path(path)
                return (
                    path.is_dir() and path.joinpath("level.dat").is_file()
                    and path.joinpath("region").is_dir()
                )


            args = sys.argv[1:]

            if len(args) == 0:
                print("No arguments provided")
                sys.exit(1)

            instdir = Path(args[0])

            savesdir = instdir.joinpath("minecraft/saves")

            if not savesdir.is_dir():
                print("No saves directory found")
                sys.exit(1)

            worlds = [world for world in savesdir.iterdir() if is_mc_world_dir(world)]

            # p = subprocess.run([
            #     zenity,
            #     "--question",
            #     "--text",
            #     f"Are you sure you want to delete all {len(worlds)} saves from {savesdir}?"
            # ])
            # if result.returncode == 0:
            #     * delete *

            p = subprocess.run([
                notifysend,
                "-u",
                "critical", "-a",
                "Minecraft Saves Delete",
                f"Are you sure you want to delete all {len(worlds)} saves from {instdir.name}?",
                "-A",
                "yes=yes",
                "-A",
                "no=no",
                ], check=True, capture_output=True)

            if p.stdout.strip().decode() == "yes":
                for worlddir in worlds:
                    print(f"Deleting {worlddir}")
                    rmtree(worlddir)
                p = subprocess.run([
                  notifysend,
                  "-a",
                  "Minecraft Saves Delete",
                  f"Successfully deleted all {len(worlds)} saves",
                  ], check=True, capture_output=True)
          '')
      ];
    }

    (
      lib.mkIf (config.lunar.modules.minecraft.cracked && config.lunar.expensiveBuilds) {
        nixpkgs.overlays = [
          # NOTE: put this overlay in the overlays folder
          # inputs.self.overlays.prismlauncher-crack
          (
            final: prev: {
              prismlauncher-unwrapped = inputs.self.packages.${system}.prismlauncher-unwrapped-crack;
              prismlauncher = inputs.self.packages.${system}.prismlauncher-crack;
            }
          )
        ];
      }
    )
  ]);
}
