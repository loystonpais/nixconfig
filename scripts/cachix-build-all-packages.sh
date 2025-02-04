# Runs nix build for all the packages

if [ -z "$1" ]; then
  echo "Usage: $0 <directory-path>"
  exit 1
fi

DIR="$1"

if [ ! -d "$DIR" ]; then
  echo "Error: $DIR is not a valid directory."
  exit 1
fi

for file in "$DIR"/*.nix; do

  # Base name of the file (without path and extension)
  BASENAME=$(basename "$file" .nix)

  echo "Building $BASENAME..."
  if nix build --print-out-paths ".#$BASENAME"; then
    echo "Build succeeded for $BASENAME."
  else
    echo "::warning::Build failed for $BASENAME."
  fi
done