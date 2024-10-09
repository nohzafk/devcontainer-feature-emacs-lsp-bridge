{ pkgs ? import <nixpkgs> { } }:
let
  lspBridgeSrc = pkgs.callPackage ./lsp-bridge.nix { };
  lspBridgeVenvDir = "/tmp/lsp-bridge-venv";
  lspBridgeLinkDir = "/tmp/lsp-bridge";
in pkgs.mkShell {

  venvDir = lspBridgeVenvDir;

  buildInputs = [ lspBridgeSrc ];

  shellHook = ''
    # Check if system Python is available
    if command -v python3 &> /dev/null && command -v pip3 &>/dev/null; then
      PYTHON_CMD="python3"
    else
      PYTHON_CMD="${pkgs.python3}/bin/python3"
    fi

    if [ ! -d "${lspBridgeVenvDir}" ]; then
      $PYTHON_CMD -m venv "${lspBridgeVenvDir}" || { echo "Failed to create virtual environment"; exit 1; }
    fi
    source "${lspBridgeVenvDir}/bin/activate" || { echo "Failed to activate virtual environment"; exit 1; }

    unset SOURCE_DATE_EPOCH

    # Use the venv's pip to install requirements
    python -m pip install --upgrade pip
    pip install -r requirements.txt || { echo "Failed to install requirements"; exit 1; }

    if [[ ! -d ${lspBridgeLinkDir} ]]; then
      ln -s ${lspBridgeSrc} ${lspBridgeLinkDir} || { echo "Failed to create symbolic link"; exit 1; }
    fi
  '';
}
