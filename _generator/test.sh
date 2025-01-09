#!/bin/bash

cd ../

if [ -n "$2" ]; then
    echo "Invalidate hash, this will force lsp-bridge-src to download the latest lsp-bridge master branch"
    sed -i 's|sha256 = .*|sha256 = "";|' "src/$1/lsp-bridge.nix"
fi

# Check if an argument is provided
if [ -n "$1" ]; then
    # If an argument is provided, use it with the --features flag
    FEATURES="--features $1"
else
    # If no argument is provided, FEATURES remains empty
    FEATURES=""
fi

# Run the command with the FEATURES variable
devcontainer features test \
  $FEATURES \
  --remote-user vscode \
  --skip-scenarios \
  --base-image mcr.microsoft.com/devcontainers/base:ubuntu \
  .