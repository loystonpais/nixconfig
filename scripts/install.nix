{
  writeShellApplication,
  git,
  nh,
  jq,
  nano,
  bw-set-age-key,
}:
writeShellApplication {
  name = "install";
  runtimeInputs = [git nh jq nano bw-set-age-key];
  text = ''
    set -e  # Exit on any failure

    # Constants
    REPO_URL="https://github.com/loystonpais/nixconfig"
    TARGET_DIR="$HOME/nixconfig"
    INSTANCES_DIR="$TARGET_DIR/instances"
    INSTANCE_DIR=""

    # Usage function
    usage() {
        echo "Usage: $0 [--sops] --hostname <hostname> [--new] [--edit]"
        exit 1
    }

    # Parse arguments
    SOPS_SETUP=false
    NEW_INSTANCE=false
    EDIT_CONFIG=false
    HOSTNAME=""

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --sops) SOPS_SETUP=true; shift ;;
            --hostname)
                [[ -n "$2" ]] || { echo "Error: --hostname requires an argument."; usage; }
                HOSTNAME="$2"
                INSTANCE_DIR="$INSTANCES_DIR/$HOSTNAME"
                shift 2
                ;;
            --new) NEW_INSTANCE=true; shift ;;
            --edit) EDIT_CONFIG=true; shift ;;
            *) echo "Unknown argument: $1"; usage ;;
        esac
    done

    [[ -z "$HOSTNAME" ]] && { echo "Error: --hostname must be specified."; usage; }

    # Function to set up SOPS key
    setup_sops() {
        echo "Setting up SOPS AGE key..."
        bw-set-age-key || { echo "Failed to set AGE key."; exit 1; }
    }

    # Function to clone repo if not present
    clone_repo() {
        if [[ ! -d "$TARGET_DIR" ]]; then
            echo "Cloning repository..."
            git clone "$REPO_URL" "$TARGET_DIR"
        else
            echo "Repository already exists. Skipping clone."
        fi
    }

    # Function to create a new flake instance
    create_instance() {
        if [[ -d "$INSTANCE_DIR" ]]; then
            echo "Error: An instance with the name '$HOSTNAME' already exists at $INSTANCE_DIR."
            exit 1
        fi

        echo "Creating new flake instance at $INSTANCE_DIR..."
        nix flake new -t .#instance "$INSTANCE_DIR"

        local current_system
        current_system=$(nix eval --impure --expr "builtins.currentSystem" | jq -r)
        sed -i "s/<system>/$current_system/g" "$INSTANCE_DIR/default.nix"

        # Handle hardware configuration
        if [[ -f "/etc/nixos/hardware-configuration.nix" ]]; then
            cp /etc/nixos/hardware-configuration.nix "$INSTANCE_DIR/"
        else
            echo "Generating hardware configuration..."
            sudo nixos-generate-config --dir "$INSTANCE_DIR"
        fi

        echo "New instance created at $INSTANCE_DIR"
    }

    # Function to edit lunar.nix if --edit is set
    edit_lunar_nix() {
        local lunar_nix="$INSTANCE_DIR/lunar.nix"

        # If the file doesn't exist, create it
        if [[ ! -f "$lunar_nix" ]]; then
            echo "Creating lunar.nix with hostname replacement..."
            echo "<hostname>" > "$lunar_nix"
        fi

        # Replace <hostname> with actual hostname
        sed -i "s/<hostname>/$HOSTNAME/g" "$lunar_nix"

        echo "Opening lunar.nix for editing..."
        nano "$lunar_nix"
    }

    # Function to run nh os switch
    run_nh_switch() {
        [[ ! -d "$INSTANCE_DIR" ]] && { echo "Error: Instance directory '$INSTANCE_DIR' does not exist."; exit 1; }
        $EDIT_CONFIG && edit_lunar_nix
        (cd "$TARGET_DIR" && git add .)  # Ensure changes are tracked
        echo "Running: nh os switch -v -H $HOSTNAME"
        (cd "$TARGET_DIR" && nh os switch -v -H "$HOSTNAME" .)
    }

    # Execute steps
    $SOPS_SETUP && setup_sops
    clone_repo
    $NEW_INSTANCE && create_instance
    run_nh_switch
  '';
}
