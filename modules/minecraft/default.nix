{
  config,
  lib,
  pkgs,
  inputs,
  system,
  ...
}: {
  imports = [
    ./mcsr
  ];

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
      lunar.modules.minecraft.mcsr.enable = lib.mkDefault true;
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

        # Collection of Glfw3
        (pkgs.linkFarm "glfw-collection" [
          {
            name = "share/glfw-collection/glfw3";
            path = pkgs.glfw3;
          }

          {
            name = "share/glfw-collection/glfw3-minecraft-cursorfix";
            path = inputs.self.packages.${system}.glfw3-minecraft-cursorfix;
          }

          {
            name = "share/glfw-collection/glfw3-waywall";
            path = inputs.self.packages.${system}.glfw3-waywall;
          }
        ])

        prismlauncher

        waywall

        inputs.self.packages.${system}.ninjabrainbot
        inputs.self.packages.${system}.zig-seed-glitchless
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
            }
          )
        ];
      }
    )
  ]);
}
