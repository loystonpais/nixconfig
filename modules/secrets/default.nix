{ lib, config, inputs, pkgs, ... }: 
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  config = lib.mkIf config.vars.modules.secrets.enable {
    
    sops.defaultSopsFile = ../../secrets/secrets.yaml;
    sops.defaultSopsFormat = "yaml";
    sops.age.keyFile = "/home/${config.vars.username}/.config/sops/age/keys.txt";

    sops.secrets.groq_personal_use_key.owner = config.vars.username;
    sops.secrets.gemini_api_key.owner = config.vars.username;
    sops.secrets.github_key.owner = config.vars.username;
    sops.secrets.nixacle_gitea_db_password.owner = config.vars.username;
    sops.secrets.gitea_key.owner = config.vars.username;
    sops.secrets.cachix_loystonpais_auth_token.owner = config.vars.username;

    vars.modules.secrets.environmentVariablesFromSops = {
      IDK_GROQ_API_KEY = config.sops.secrets.groq_personal_use_key;
      GROQ_API_KEY = config.sops.secrets.groq_personal_use_key;
      GEMINI_API_KEY = config.sops.secrets.gemini_api_key;
      GITHUB_KEY = config.sops.secrets.github_key;
      GITEA_KEY = config.sops.secrets.gitea_key;
      
      CACHIX_LOYSTONPAIS_AUTH_TOKEN = config.sops.secrets.cachix_loystonpais_auth_token;
      CACHIX_AUTH_TOKEN = config.sops.secrets.cachix_loystonpais_auth_token;
    };

    environment.systemPackages = with pkgs; [
      sops
    ];

  };  
}