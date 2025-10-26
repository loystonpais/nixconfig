{
  config,
  osConfig,
  lib,
  ...
}: {
  config = lib.mkIf osConfig.lunar.modules.plasma.home.enable {
    programs.plasma.input.mice = [
      {
        accelerationProfile = "none";
        name = "Logitech Gaming Mouse G402";
        vendorId = "046d";
        productId = "c07e";
      }
    ];
  };
}
