{ config, lib, pkgs, inputs, settings, ... }:

{
  # Set your time zone.
  time.timeZone = settings.timeZone;

  # Select internationalisation properties.
  i18n.defaultLocale = settings.defaultLocale;

  i18n.extraLocaleSettings = {
    LC_ADDRESS = settings.defaultLocale;
    LC_IDENTIFICATION = settings.defaultLocale;
    LC_MEASUREMENT = settings.defaultLocale;
    LC_MONETARY = settings.defaultLocale;
    LC_NAME = settings.defaultLocale;
    LC_NUMERIC = settings.defaultLocale;
    LC_PAPER = settings.defaultLocale;
    LC_TELEPHONE = settings.defaultLocale;
    LC_TIME = settings.defaultLocale;
  };
}
