{ config, inputs, lib, pkgs, ... }: {

  config = {
    specialisation.productive =
      let wallpaper = "${inputs.self}/assets/wallpapers/green-leaves.jpg";
      in {
        configuration = {
          system.nixos.tags = [ "productive" ];
          home-manager.users.${config.lunar.username} = {
            imports = [ ./home.nix ];
          };
        };
      };
  };

}
