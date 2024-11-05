{ lib, config, inputs, ... }: 
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  config = lib.mkIf config.vars.modules.secrets.enable {
    
    sops.defaultSopsFile = ../../secrets/secrets.yaml;
    sops.defaultSopsFormat = "yaml";
    sops.age.keyFile = "/home/${config.vars.username}/.config/sops/age/keys.txt";

    sops.secrets.groq_personal_use_key.owner = config.vars.username;
    

    vars.modules.secrets.environmentVariablesFromSops = {
      IDK_GROQ_API_KEY = config.sops.secrets.groq_personal_use_key;
      GROQ_API_KEY = config.sops.secrets.groq_personal_use_key;
    };

  };  
}