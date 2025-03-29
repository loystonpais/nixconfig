{
  writeShellApplication,
  bitwarden-cli,
}:
writeShellApplication {
  name = "bw-set-age-key";
  runtimeInputs = [bitwarden-cli];
  text = ''
    set -e

    AGE_KEYS_FILE="$HOME/.config/sops/age/keys.txt"
    mkdir -p "$(dirname "$AGE_KEYS_FILE")"

    # Allow logout failure (already logged out) without stopping the script
    bw logout &>/dev/null || true

    echo -n "Email: "
    read -rs BW_EMAIL
    echo ""

    echo -n "Password: "
    read -rs BW_PASSWORD
    echo ""

    echo "Logging into Bitwarden..."
    if ! BW_SESSION=$(bw login "$BW_EMAIL" "$BW_PASSWORD" --raw 2>/dev/null); then
        echo "Failed to log in to Bitwarden."
        exit 1
    fi
    echo "Login successful."

    echo "Retrieving AGE key from Bitwarden..."
    if ! AGE_KEY=$(bw get password 47820e18-b2e6-43dd-84fa-b21c00ca18eb --session "$BW_SESSION"); then
        echo "Failed to retrieve a valid AGE key."
        exit 1
    fi

    bw lock &>/dev/null || echo "Warning: Failed to lock Bitwarden session."

    unset BW_SESSION

    if [[ -n "$AGE_KEY" ]]; then
        if grep -Fxq "$AGE_KEY" "$AGE_KEYS_FILE" 2>/dev/null; then
            echo "AGE key already exists. Skipping addition."
        else
            echo "$AGE_KEY" >> "$AGE_KEYS_FILE"
            echo "AGE key successfully added to $AGE_KEYS_FILE"
        fi
    else
        echo "Invalid AGE key received."
        exit 1
    fi

  '';
}
