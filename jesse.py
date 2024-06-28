#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3 python3Packages.typer python3Packages.rich

import typer

from typing_extensions import Annotated
from typing import Optional

import os
import shutil
import platform

try:
    from rich import print
except ImportError:
    pass

current_dir = "."
nixos_instances_path = current_dir + "/" +  "nixos-instances"

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

app = typer.Typer()

@app.command()
def yo(name: str):
    print(f"Yo! {name}")

@app.command()
def walter(n: int):
    print(f"You can't keep gettin' away with this\n" * n)


nixos_instance = typer.Typer(help="Manage nixos instances")

@nixos_instance.command()
def create(instance: str):
    if not instance.isidentifier():
        raise ValueError(f"{instance!r} is not a valid identifier")
    
    system = get_nix_architecture()
    if system is None:
        Exception("Unable to form system string. Probably unsupported architecture")
    
    try:
      os.mkdir(dir := nixos_instances_path + "/" + instance)
    except FileExistsError:
        raise FileExistsError(f"Instance {instance!r} already exists")

    shutil.copy("/etc/nixos/configuration.nix", dir)
    shutil.copy("/etc/nixos/hardware-configuration.nix", dir)
    
    template = '''
{{ self, inputs, ... }}: 

inputs.nixpkgs-unstable.lib.nixosSystem {{
  system = "{system}";

  specialArgs = {{
    inherit inputs;
  }};

  modules = [
    ./configuration.nix
    ./hardware-configuration.nix
  ];
}}
'''

    with open(dir + "/default.nix", "w") as f:
        f.write(template.format(system=system))

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