{
  config,
  lib,
  ...
}: let
  inherit (lib) mkDefault;
in {
  # Set your time zone.
  time.timeZone = mkDefault config.lunar.timeZone;

  # Select internationalisation properties.
  i18n.defaultLocale = mkDefault config.lunar.locale;

  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "en_GB.UTF-8/UTF-8"
    "en_IN/UTF-8"
  ];

  i18n.extraLocaleSettings = {
    LC_ADDRESS = mkDefault config.lunar.locale;
    LC_IDENTIFICATION = mkDefault config.lunar.locale;
    LC_MEASUREMENT = mkDefault config.lunar.locale;
    LC_MONETARY = mkDefault config.lunar.locale;
    LC_NAME = mkDefault config.lunar.locale;
    LC_NUMERIC = mkDefault config.lunar.locale;
    LC_PAPER = mkDefault config.lunar.locale;
    LC_TELEPHONE = mkDefault config.lunar.locale;
    LC_TIME = mkDefault config.lunar.locale;
  };
}
