#!/run/current-system/sw/bin/bash

import_hardware_config_path="/etc/nixos/hardware-configuration.nix"
hardware_config_path="hardware-configuration.nix"

set -e  # Exit immediately if a command exits with a non-zero status

backup_hardware_config() {
  echo "Backing up $hardware_config_path file"
  mv "$hardware_config_path" "$hardware_config_path".bak
}

import_hardware_config() {
  backup_hardware_config

  printf "Importing hardware configuration from $import_hardware_config_path: "

  cp "$import_hardware_config_path" .
  if [ "$?" -ne 0 ]; then
    echo "Failed"
    exit 1
  fi

  echo "Success"
}

undo_hardware_config() {
  echo "Undoing.."
  mv "$hardware_config_path".bak "$hardware_config_path"
}

build() {
  if [ -f /run/current-system/sw/bin/nh ]; then
    echo "nh exists"
    echo Building using nh command
    nh os switch .
  else
    sudo nixos-rebuild switch --flake .
  fi
}

if [ "$1" = "--keep" ]; then
  build

elif [ "$1" = "--undo" ]; then
  undo_hardware_config

elif [ "$1" = "--fast" ]; then
  import_hardware_config
  build

elif [ "$1" = "" ]; then
  echo Please verify the settings
  sleep 1
  $EDITOR settings.nix
  import_hardware_config
  build

else
  echo "Bad arguments.. Nothing changed"
  exit 1
fi

