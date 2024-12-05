#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3 python3Packages.typer python3Packages.rich

import typer

from typing_extensions import Annotated
from typing import Optional

import json
import os
import shutil
import platform
from textwrap import dedent
import re

try:
    from rich import print
except ImportError:
    pass






try:
    json_data = json.load(open(".json"))
except Exception as e:
    raise Exception(f".json failed to load, {e}")

nixos_instances_path = json_data["nixosInstancesPath"]
nixos_profiles_path = json_data["nixosProfilesPath"]




class Utils:

    @staticmethod
    def get_nix_architecture():
        system = platform.system()
        machine = platform.machine()

        if system == 'Linux':
            if machine == 'x86_64':
                return 'x86_64-linux'
            elif machine == 'aarch64':
                return 'aarch64-linux'
            elif machine.startswith('arm') or machine.startswith('armv'):
                return 'arm-linux'
            else:
                return f"{machine.lower()}-linux"
        else:
            return None
        
    @staticmethod
    def is_valid_hostname(hostname):
        pattern = r"^$|^[a-zA-Z0-9]([a-zA-Z0-9_-]{0,61}[a-zA-Z0-9])?$"
        return bool(re.match(pattern, hostname)) 
        







app = typer.Typer(help="Jesse the nix config helper")

@app.command()
def yo(name: str):
    print(f"Yo! {name}")

@app.command()
def walter(n: int):
    print(f"You can't keep gettin' away with this\n" * n)


nixos_instance = typer.Typer(help="Manage nixos instances")

@nixos_instance.command(name="import")
def import_(instance: str):
    if not Utils.is_valid_hostname(instance):
        raise ValueError(f"{instance!r} is not a valid hostname")
    
    system = Utils.get_nix_architecture()
    if system is None:
        Exception("Unable to form system string. Probably unsupported architecture")
    
    try:
      os.mkdir(dir := nixos_instances_path + "/" + instance)
    except FileExistsError:
        raise FileExistsError(f"Instance {instance!r} already exists")
    
    modules = []

    
    shutil.copy("/etc/nixos/hardware-configuration.nix", dir)
    shutil.copy("/etc/nixos/configuration.nix", dir)
    modules.append("./configuration.nix")

    default_file = dedent(f'''
    {{ self, inputs, ... }}:

    inputs.nixpkgs.lib.nixosSystem rec {{
      system = "{system}";

      specialArgs = {{
        inherit inputs;
        inherit system;
      }};

      modules = [  {"  ".join(modules)}  ];

    }}
    ''')

    with open(dir + "/default.nix", "w") as f:
        f.write(default_file)

    print(f"Imported to a new instance {instance!r}")
    
@nixos_instance.command()
def create(instance: str):
    raise NotImplementedError
    if not Utils.is_valid_hostname(instance):
        raise ValueError(f"{instance!r} is not a valid hostname")
    
    system = Utils.get_nix_architecture()
    if system is None:
        Exception("Unable to form system string. Probably unsupported architecture")
    print(f"Using current system architecture {system!r}")

    try:
      os.mkdir(dir := nixos_instances_path + "/" + instance)
    except FileExistsError:
        raise FileExistsError(f"Instance {instance!r} already exists")
    
    print("Using system's hardware configuration")
    shutil.copy("/etc/nixos/hardware-configuration.nix", dir)

    default_file = dedent(f'''
    # It is not recommended to modify this file
    # Do modifications in configuration.nix
    {{ self, inputs, ... }}:

    inputs.nixpkgs.lib.nixosSystem {{
      system = "{system}";

      specialArgs = {{
        inherit inputs;
      }};

      modules = [  
        # DONT
        ../../defvars.nix
        ../../users.nix

        ./hardware-configuration.nix
      ];

    }}
    ''')

    with open(dir + "/default.nix", "w") as f:
        f.write(default_file)

    print(f"Created new instance {instance!r}")
        
@nixos_instance.command()
def delete(instance: str):
    dir = nixos_instances_path + "/" + instance

    if not os.path.exists(dir):
        raise FileExistsError(f"Instance {instance!r} does not exist")

    shutil.rmtree(dir)
    print(f"Deleted instance {instance!r}")
    
    

app.add_typer(nixos_instance, name="nixos-instance")



if __name__ == "__main__":
    app()