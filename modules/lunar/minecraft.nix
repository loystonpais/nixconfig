{
  den,
  inputs,
  ...
}: {
  lunar.minecraft = {
    nixos = {
      pkgs,
      lib,
      ...
    }: {
      config = lib.mkMerge [
        {
          # Accessible from /etc/java-collection/
          # Example: /etc/java-collection/jdk17/bin/java
          environment.etc."java-collection/jdk17".source = pkgs.jdk17;
          environment.etc."java-collection/jdk21".source = pkgs.jdk21;

          environment.etc."glfw-collection/glfw3".source = pkgs.glfw3;
          environment.etc."glfw-collection/glfw3-waywall".source = inputs.self.packages.${pkgs.system}.glfw3-waywall;

          environment.systemPackages = with pkgs; [
            prismlauncher

            waywall

            inputs.self.packages.${pkgs.system}.ninjabrainbot
            inputs.self.packages.${pkgs.system}.zig-seed-glitchless
          ];
        }
      ];
    };
  };
}
