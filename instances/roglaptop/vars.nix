# Define your vars/settings here
# These are not the only options, checkout defvars.nix 
# for a list of all the options
# Some of them have default values, a few of them don't 
# so you have to expicitly define them, preferably here

{ ... }:

{
  # Host name is generated for you from the instance name
  # Feel free to modifify it
  vars.hostName = "roglaptop";
  vars.graphicsMode = "asuslinux";
  vars.bootMode = "uefi";

  # Set your profile
  vars.profile.everything.enable = true;

  # Exclusion
  vars.modules.browsers.floorp.enable = true;
  vars.modules.waydroid.enable = false;
  vars.modules.samba.enable = false;

}
