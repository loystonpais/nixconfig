{ config, lib, pkgs, inputs, settings, ... }:

{

  # Virtualization based on libvirtd

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;


  #virtualisation.tpm.enable = true;

  environment.systemPackages = with pkgs; [

  ];
}
