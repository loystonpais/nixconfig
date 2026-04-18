{den, ...}: {
  lunar.misc = {
    nixos = {pkgs, ...}: {
      programs.kdeconnect.enable = true;

      environment.variables.OLLAMA_NOPRUNE = "true";

      environment.systemPackages = with pkgs; [wl-clipboard];
    };
  };
}
