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
    ./nixcraft
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
      lunar.modules.nixcraft.enable = true;

      # Accessible from /etc/java-collection/
      # Example: /etc/java-collection/jdk17/bin/java
      environment.etc."java-collection/jdk17".source = pkgs.jdk17;
      environment.etc."java-collection/jdk21".source = pkgs.jdk21;

      environment.etc."glfw-collection/glfw3".source = pkgs.glfw3;
      environment.etc."glfw-collection/glfw3-minecraft-cursorfix".source = inputs.self.packages.${system}.glfw3-minecraft-cursorfix;
      environment.etc."glfw-collection/glfw3-waywall".source = inputs.self.packages.${system}.glfw3-waywall;

      environment.systemPackages = with pkgs; [
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
