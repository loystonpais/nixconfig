#! /usr/bin/env nix-shell
#! nix-shell -i bash -p jq

# Nix Configuration Management Helper (AI Generated)
# Provides utilities for managing NixOS instances and configurations

# Configuration loading
load_config() {
    if [[ ! -f ".json" ]]; then
        echo "Error: Configuration file '.json' not found" >&2
        exit 1
    fi
    
    # Parse configuration using jq
    NIXOS_INSTANCES_PATH=$(jq -r '.nixosInstancesPath' .json)
    NIXOS_PROFILES_PATH=$(jq -r '.nixosProfilesPath' .json)

    if [[ -z "$NIXOS_INSTANCES_PATH" ]]; then
        echo "Error: Invalid configuration - missing nixosInstancesPath" >&2
        exit 1
    fi
}

# Detect system architecture
get_system_architecture() {
    local system=$(uname -s)
    local machine=$(uname -m)

    case "$system" in
        Linux)
            case "$machine" in
                x86_64) echo "x86_64-linux" ;;
                aarch64) echo "aarch64-linux" ;;
                arm*) echo "arm-linux" ;;
                *) echo "${machine,,}-linux" ;;
            esac
            ;;
        *)
            echo ""
            ;;
    esac
}

# Validate hostname format
validate_hostname() {
    local hostname="$1"
    [[ "$hostname" =~ ^$|^[a-zA-Z0-9]([a-zA-Z0-9_-]{0,61}[a-zA-Z0-9])?$ ]]
}

# Create a new NixOS instance
create_nixos_instance() {
    local instance="$1"
    
    # Validate hostname
    if ! validate_hostname "$instance"; then
        echo "Error: '${instance}' is an invalid hostname" >&2
        exit 1
    fi

    # Detect system architecture
    local system=$(get_system_architecture)
    if [[ -z "$system" ]]; then
        echo "Error: Unable to determine system architecture" >&2
        exit 1
    fi

    # Prepare instance directory
    local dir="${NIXOS_INSTANCES_PATH}/${instance}"
    if [[ -d "$dir" ]]; then
        echo "Error: Instance '${instance}' already exists" >&2
        exit 1
    fi
    mkdir -p "$dir"

    # Copy or generate configuration files
    copy_or_generate_config "$dir"

    # Generate default.nix
    cat << EOF > "${dir}/default.nix"
{ self, inputs, ... }:

inputs.nixpkgs.lib.nixosSystem rec {
  system = "${system}";

  specialArgs = {
    inherit inputs;
    inherit system;
  };

  modules = [

    self.nixosModules.default
    self.nixosModules.extras.home-manager.unstable

    ./hardware-configuration.nix
    ./configuration.nix
  ];
}
EOF

    echo "Successfully created NixOS instance: '${instance}'"
}

# Remove an existing NixOS instance
remove_nixos_instance() {
    local instance="$1"
    local dir="${NIXOS_INSTANCES_PATH}/${instance}"

    if [[ ! -d "$dir" ]]; then
        echo "Error: Instance '${instance}' does not exist" >&2
        exit 1
    fi

    # Prompt for confirmation
    read -p "Are you sure you want to delete the instance '${instance}'? (y/N): " confirm
    if [[ "$confirm" != [yY] && "$confirm" != [yY][eE][sS] ]]; then
        echo "Deletion cancelled."
        exit 0
    fi

    rm -rf "$dir"
    echo "Successfully deleted NixOS instance: '${instance}'"
}

# List existing NixOS instances
list_nixos_instances() {
    if [[ ! -d "$NIXOS_INSTANCES_PATH" ]]; then
        echo "No NixOS instances directory found." >&2
        exit 1
    fi

    echo "Existing NixOS Instances:"
    ls -1 "$NIXOS_INSTANCES_PATH" || echo "Unable to list instances."
}

# Copy or generate configuration files
copy_or_generate_config() {
    local dir="$1"
    local hardware_config="/etc/nixos/hardware-configuration.nix"
    local system_config="/etc/nixos/configuration.nix"

    # Attempt to copy existing configuration files
    if [[ -f "$hardware_config" ]] && [[ -f "$system_config" ]]; then
        if cp "$hardware_config" "$dir/" && cp "$system_config" "$dir/"; then
            echo "Copied existing configuration files successfully."
            return 0
        fi
    fi

    # If copy fails or files don't exist, generate new configuration
    echo "Existing configuration files not found or copy failed. Generating new configuration..." >&2

    echo "NOTE: Falling back to nixos-generate-config. It needs root perms to generate the config." >&2
    
    # Use sudo to run nixos-generate-config if needed
    if ! sudo nixos-generate-config --dir "$dir"; then
        echo "Error: Failed to generate NixOS configuration" >&2
        # Clean up the directory if generation fails
        rm -rf "$dir"
        exit 1
    fi

    # Ensure files are readable
    sudo chown "$(whoami)" "$dir/hardware-configuration.nix"
    sudo chown "$(whoami)" "$dir/configuration.nix"

    echo "Generated new NixOS configuration in ${dir}"
}

# Display script usage information
show_usage() {
    echo "NixOS Configuration Management"
    echo "Usage:"
    echo "  $0 create <instance-name>    Create a new NixOS instance"
    echo "  $0 remove <instance-name>    Remove an existing NixOS instance"
    echo "  $0 list                      List all NixOS instances"
    exit 1
}

# Main script entry point
main() {
    # Load configuration first
    load_config

    # Route commands
    case "$1" in
        create)
            [[ -z "$2" ]] && show_usage
            create_nixos_instance "$2"
            ;;
        remove)
            [[ -z "$2" ]] && show_usage
            remove_nixos_instance "$2"
            ;;
        list)
            list_nixos_instances
            ;;
        *)
            show_usage
            ;;
    esac
}

# Ensure at least one argument is provided
[[ $# -eq 0 ]] && show_usage

# Execute main function with all arguments
main "$@"
