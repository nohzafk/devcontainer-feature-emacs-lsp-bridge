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
    if command -v python3 &> /dev/null; then
      PYTHON_CMD="python3"
      # Use system pip to install virtualenv
      pip3 install --user virtualenv
      VIRTUALENV_CMD="$HOME/.local/bin/virtualenv"
    else
      PYTHON_CMD="${pkgs.python3}/bin/python3"
      VIRTUALENV_CMD="${pkgs.python3Packages.virtualenv}/bin/virtualenv"
    fi

    if [ ! -d "${lspBridgeVenvDir}" ]; then
      $VIRTUALENV_CMD "${lspBridgeVenvDir}"
    fi
    source "${lspBridgeVenvDir}/bin/activate"
    
    unset SOURCE_DATE_EPOCH

    pip install -r requirements.txt

    if [[ ! -d ${lspBridgeLinkDir} ]]; then
      ln -s ${lspBridgeSrc} ${lspBridgeLinkDir}
    fi
  '';
}
