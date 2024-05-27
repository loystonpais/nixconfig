{ config, lib, pkgs, settings, ... }:

{

environment.systemPackages = with pkgs; [
    godot_4
  ];
}
