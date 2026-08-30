{
  den,
  lunar,
  ...
}: {
  den.homes.aarch64-darwin."loyston_pais@maple" = {};

  den.aspects.loyston_pais = {
    includes = [
      lunar.dev
    ];

    homeManager = {...}: {
      programs.zsh.initContent = ''
        if [ -x /opt/homebrew/bin/brew ]; then
          eval "$(/opt/homebrew/bin/brew shellenv zsh)"
        fi
      '';
    };
  };
}
