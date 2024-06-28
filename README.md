# Welcome to my nix config (v2)

Hi! This is my version of nix configuration.

# Guide (Automatic)

Yet to write.


# Guide (Manual)

The usage of the word "instances" over "hosts" is on purpose. This config is designed to handle multiple instances of nixos regardless of which device it is running on.

Just installed nixos and now you want to use this config? run 
```sh 
./jesse.py nixos-instance import instanceName
```
Replace `instanceName` with any name you want, make sure it's a valid hostname as well.
Note: By default, the unstable branch is used.


<br/>
When you run the above jesse command, a new folder named `instanceName` is created in the `instances` folder. (This folder path can also be changed, along with others. Checkout the `.json` file) <br/>
On opening the folder you'll see a default.nix file containing something like

```nix
{ self,  inputs,  ... }:
# can change nixpkgs below with nixpkgs-stable
inputs.nixpkgs.lib.nixosSystem {
  system  =  "x86_64-linux";
  
  specialArgs  = {
    inherit  inputs;
  };
  
  modules = [
    ../../core.nix
    ./configuration.nix
    ./hardware-configuration.nix
  ];
}
```

As you can see, it also imports `core.nix`, a file that sets up some useful features.

Now, go to the `configuration.nix` file and remove everything except the state version.
Add, 
```nix
vars.hostName = "anyhostname";
vars.graphicsMode = "none";
vars.bootMode = "uefi"; # change to bios if you are booting from bios
vars.profile.everything.enable = true; # enables almost everyting set up in the config
```
That should suffice to be able to run `sudo nixos-rebuild --flake .#instanceName` but wait! Go to `defvars.nix`, read it, and change the default values wherever you can because now it's all your config. (Some options do not have defaults which is why I told you to add them to the config, lol)
I'd also recommend going through `core.nix` and checking out `profiles` folder