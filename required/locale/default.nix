{ config, lib, ... }: {
  # Set your time zone.
  time.timeZone = config.lunar.timeZone;

  # Select internationalisation properties.
  i18n.defaultLocale = config.lunar.locale;

  i18n.extraLocaleSettings = {
    LC_ADDRESS = config.lunar.locale;
    LC_IDENTIFICATION = config.lunar.locale;
    LC_MEASUREMENT = config.lunar.locale;
    LC_MONETARY = config.lunar.locale;
    LC_NAME = config.lunar.locale;
    LC_NUMERIC = config.lunar.locale;
    LC_PAPER = config.lunar.locale;
    LC_TELEPHONE = config.lunar.locale;
    LC_TIME = config.lunar.locale;
  };
}