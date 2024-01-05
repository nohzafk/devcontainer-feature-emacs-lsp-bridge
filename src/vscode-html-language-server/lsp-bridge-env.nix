{ pkgs ? import <nixpkgs> { } }:
let
  lspBridgeSrc = pkgs.callPackage ./lsp-bridge.nix { };
  lspBridgeVenvDir = "/tmp/lsp-bridge-venv";
  lspBridgeLinkDir = "/tmp/lsp-bridge";
in pkgs.mkShell {

  venvDir = lspBridgeVenvDir;

  buildInputs = [    
    pkgs.python311Packages.venvShellHook 
    lspBridgeSrc
  ];

  # this is run once only, after the virtual environment is created
  postVenvCreation = ''
    # ensure that the build will not be affected by changes in the system time
    unset SOURCE_DATE_EPOCH

    pip install -r requirements.txt
  '';

  postShellHook = ''
    if [[ ! -d ${lspBridgeLinkDir} ]]; then
      ln -s ${lspBridgeSrc} ${lspBridgeLinkDir}
    fi
  '';
}
