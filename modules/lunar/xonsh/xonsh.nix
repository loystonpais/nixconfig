{den, ...}: {
  lunar.xonsh = {
    nixos = {pkgs, ...}: {
      programs.xonsh = {
        enable = true;
        extraPackages = ps:
          with ps; [
            numpy
            xonsh.xontribs.xontrib-vox
            xonsh.xontribs.xonsh-direnv
            # coconut #? Doesn't work because of python verison mismatch
            requests
            groq
          ];
      };
    };

    homeManager = {
      config,
      pkgs,
      ...
    }: {
      imports = [
        ./_external-home-module.nix
      ];

      programs.xonsh = {
        enable = true;
        sessionVariables = config.home.sessionVariables;
        configFooter = ''
          if __name__ == "__main__":
            pass
        '';
      };

      home.file.".config/xonsh/rc.d" = {
        recursive = true;
        source = ./rc.d;
      };

      programs.xonsh.aliases = {
        ls = "lsd";
        lst = "lsd -tr";
        la = "lsd -alh";
      };

      home.packages = with pkgs; [
        lsd
      ];
    };
  };
}
