## Generate a template module

name = ARGV[0]

`mkdir -p modules/#{name}`

default_nix = "
{
  config,
  lib,
  ...
}: {
  options.lunar.modules.#{name} = {
    enable = lib.mkEnableOption \"#{name}\";
    home.enable = lib.mkEnableOption \"#{name} home-manager\";
  };

  config = lib.mkIf config.lunar.modules.#{name}.enable (lib.mkMerge [
    {
      lunar.modules.#{name}.home.enable = lib.mkDefault true;
      home-manager.users.${config.lunar.username}.imports = [
        ./home.nix
      ];
    }
  ]);
}
"

home_nix = "
{
  osConfig,
  config,
  lib,
  ...
}: {
  config = lib.mkIf osConfig.lunar.modules.#{name}.enable (lib.mkMerge [
    {
     # Home config here
    }
  ]);
}
"

open("modules/#{name}/default.nix", 'w') do |file|
  file.write(default_nix)
end

open("modules/#{name}/home.nix", 'w') do |file|
  file.write(home_nix)
end
