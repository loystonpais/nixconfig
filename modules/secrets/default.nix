{
  lib,
  config,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  config = lib.mkIf config.lunar.modules.secrets.enable {
    sops.defaultSopsFile = ../../secrets/secrets.yaml;
    sops.defaultSopsFormat = "yaml";
    sops.age.keyFile = "/home/${config.lunar.username}/.config/sops/age/keys.txt";

    sops.secrets.groq-personal-use-key.owner = config.lunar.username;
    sops.secrets.gemini-api-key.owner = config.lunar.username;
    sops.secrets.github-key.owner = config.lunar.username;
    sops.secrets.nixacle-gitea-db-password.owner = config.lunar.username;
    sops.secrets.gitea-key.owner = config.lunar.username;
    sops.secrets.cachix-loystonpais-auth-token.owner = config.lunar.username;
    sops.secrets.ataraxy-bot-token.owner = config.lunar.username;
    sops.secrets.ataraxy-environment-file.owner = config.lunar.username;
    sops.secrets.wireguard-server-common-private-key.owner = config.lunar.username;
    sops.secrets."wireguard-client-${config.lunar.hostName}-private-key" = lib.mkIf (config.lunar.modules.vpn.wireguard.enableMode == "client" && config.lunar.modules.vpn.wireguard.clientPrivateKeyInSops) {owner = config.lunar.username;};

    lunar.modules.secrets.environmentVariablesFromSops = {
      IDK_GROQ_API_KEY = config.sops.secrets.groq-personal-use-key;
      GROQ_API_KEY = config.sops.secrets.groq-personal-use-key;
      GEMINI_API_KEY = config.sops.secrets.gemini-api-key;
      GITHUB_KEY = config.sops.secrets.github-key;
      GITEA_KEY = config.sops.secrets.gitea-key;

      CACHIX_LOYSTONPAIS_AUTH_TOKEN = config.sops.secrets.cachix-loystonpais-auth-token;
      CACHIX_AUTH_TOKEN = config.sops.secrets.cachix-loystonpais-auth-token;

      ATARAXY_BOT_TOKEN = config.sops.secrets.ataraxy-bot-token;
    };

    sops.secrets.auto-resume-builder = {
      format = "dotenv";
      sopsFile = ../../secrets/auto-resume-builder.env;
      key = "";
      owner = config.lunar.username;
    };

    sops.secrets."business-profile.jpg" = {
      format = "binary";
      sopsFile = ../../secrets/files/business-profile.jpg.enc;
      owner = config.lunar.username;
    };

    sops.secrets."college-logo.jpg" = {
      format = "binary";
      sopsFile = ../../secrets/files/college-logo.jpg.enc;
      owner = config.lunar.username;
    };

    environment.systemPackages = with pkgs; [
      sops
    ];
  };
}
