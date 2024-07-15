#!/bin/bash
set -e
echo "(*) Executing post-installation steps..."

# Import add_nixpkgs_prefix
. ./utils.sh

# Install list of packages in profile if specified.
if [ ! -z "${PACKAGES}" ] && [ "${PACKAGES}" != "none" ]; then
  if [ "${USEATTRPATH}" = "true" ]; then
    PACKAGES=$(add_nixpkgs_prefix "$PACKAGES")
    echo "Installing packages \"${PACKAGES}\" in profile..."
    nix-env -iA ${PACKAGES}
  else
    echo "Installing packages \"${PACKAGES}\" in profile..."
    nix-env --install ${PACKAGES}
  fi
fi

# Install Nix flake in profile if specified
if [ ! -z "${FLAKEURI}" ] && [ "${FLAKEURI}" != "none" ]; then
  echo "Installing flake ${FLAKEURI} in profile..."
  nix profile install "${FLAKEURI}"
fi

# use nix-shell to create a virtualenv and exit
nix-env -i -f ./lsp-bridge.nix
nix-shell ./lsp-bridge-env.nix --command "echo 'finish lsp bridge env setup'"
cp -f ./lsp-bridge-start.sh /tmp/lsp-bridge-start.sh

# nix-collect-garbage --delete-old
# nix-store --optimise
