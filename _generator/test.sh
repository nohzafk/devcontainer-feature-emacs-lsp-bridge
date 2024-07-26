#!/bin/bash

cd ../

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

devcontainer features test \
  $FEATURES \
  --remote-user root \
  --skip-scenarios \
  --base-image mcr.microsoft.com/devcontainers/base:debian \
  .
