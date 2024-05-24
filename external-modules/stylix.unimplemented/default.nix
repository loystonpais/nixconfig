# THIS MODULE IS NOT SET UP AND HENCE IT IS NOT USED

{ config, lib, pkgs, inputs, settings, ... }:

{
  imports = [];

  stylix.image = "${inputs.self}" + "/assets/background1.jpeg";

  stylix.polarity = "dark";

}
