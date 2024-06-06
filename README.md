# Welcome to my nixconfig

This is a config for those who want things to work. No fancy customizations or other shenanigans are encourged.
</br> NOTE: It uses KDE Plasma 6 and has configs revolving around this desktop environment.

# How to run

For first time runners
```sh
git clone <repo url>
cd <repo directory>

# Your system's hardware configuration will be borrowed
# from /etc/nixos/hardware-configuration.nix
# A new backup file will be created of the repo's
# hardware configuration file
# On running this, you will be asked to modify
# settings.nix file according to your need
./build.sh --init && ./build.sh

```

Then you can either run `./build.sh` or `./build.sh --fast` to skip settings check
