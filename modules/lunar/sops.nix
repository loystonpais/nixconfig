{
  den,
  inputs,
  lib,
  ...
}: {
  lunar.sops = {
    host,
    user,
    ...
  }: {
    nixos = {
      config,
      pkgs,
      ...
    }: let
      vars = config.sops.secrets or {};
    in {
      imports = [
        inputs.sops-nix.nixosModules.sops
      ];

      sops = {
        defaultSopsFile = "${inputs.self.outPath}/secrets/secrets.yaml";
        defaultSopsFormat = "yaml";
        age.keyFile = "/root/.loystonpais-sops-age-keys";
      };

      environment.systemPackages = [pkgs.sops];

      sops.secrets = {
        groq-personal-use-key.owner = config.users.users.${user.userName}.name;
        gemini-api-key.owner = config.users.users.${user.userName}.name;
        github-key.owner = config.users.users.${user.userName}.name;
        openrouter-key.owner = config.users.users.${user.userName}.name;
        cachix-loystonpais-auth-token.owner = config.users.users.${user.userName}.name;
      };

      sops.secrets = {
        wireguard-server-common-private-key.owner = config.users.users.${user.userName}.name;
        "wireguard-client-${config.networking.hostName}-private-key".owner = config.users.users.${user.userName}.name;
      };

      sops.secrets = {
        mc-offline-username.owner = config.users.users.${user.userName}.name;
        mc-offline-uuid.owner = config.users.users.${user.userName}.name;
      };

      sops.secrets = {
        "business-profile.jpg" = {
          format = "binary";
          sopsFile = ../../secrets/files/business-profile.jpg.enc;
          owner = config.users.users.${user.userName}.name;
        };
        "college-logo.jpg" = {
          format = "binary";
          sopsFile = ../../secrets/files/college-logo.jpg.enc;
          owner = config.users.users.${user.userName}.name;
        };
        "rclone.conf" = {
          format = "ini";
          sopsFile = ../../secrets/rclone.ini;
          owner = config.users.users.${user.userName}.name;
        };
      };

      sops.secrets = {
        ataraxy-bot-token.owner = config.users.users.${user.userName}.name;
        ataraxy-environment-file.owner = config.users.users.${user.userName}.name;
      };

      sops.secrets = {
        loy-ftp-sh-dns-update-url.owner = config.users.users.${user.userName}.name;
        nixacle-gitea-db-password.owner = config.users.users.${user.userName}.name;
        gitea-key.owner = config.users.users.${user.userName}.name;
      };
    };

    homeManager = {osConfig, ...}: let
      vars = {
        IDK_GROQ_API_KEY = osConfig.sops.secrets.groq-personal-use-key;
        GROQ_API_KEY = osConfig.sops.secrets.groq-personal-use-key;
        GEMINI_API_KEY = osConfig.sops.secrets.gemini-api-key;
        GITHUB_KEY = osConfig.sops.secrets.github-key;
        GITEA_KEY = osConfig.sops.secrets.gitea-key;

        CACHIX_LOYSTONPAIS_AUTH_TOKEN = osConfig.sops.secrets.cachix-loystonpais-auth-token;
        CACHIX_AUTH_TOKEN = osConfig.sops.secrets.cachix-loystonpais-auth-token;

        ATARAXY_BOT_TOKEN = osConfig.sops.secrets.ataraxy-bot-token;

        OPENROUTER_KEY = osConfig.sops.secrets.openrouter-key;

        MC_OFFLINE_USERNAME = osConfig.sops.secrets.mc-offline-username;
        MC_OFFLINE_UUID = osConfig.sops.secrets.mc-offline-uuid;
      };

      toEnvVar = str:
        lib.toUpper (
          builtins.replaceStrings
          ["-" "." " " "/"]
          ["_" "_" "_" "_"]
          str
        );
    in {
      programs.zsh.initContent = lib.mkIf (vars != {}) (
        builtins.concatStringsSep "\n" (map (name: ''export '${name}'="$(cat ${vars.${name}.path})"'') (builtins.attrNames vars))
      );

      home.file.".profile".text = lib.mkIf (vars != {}) (
        builtins.concatStringsSep "\n" (map (name: ''export '${name}'="$(cat ${vars.${name}.path})"'') (builtins.attrNames vars))
      );
    };
  };
}
