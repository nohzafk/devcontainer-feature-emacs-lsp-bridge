{ pkgs ? import <nixpkgs> { } }:

pkgs.stdenv.mkDerivation {
  pname = "lsp-bridge-src";
  version = "20240105";
  src = pkgs.fetchFromGitHub {
    owner = "nohzafk";
    repo = "lsp-bridge";
    rev = "feature/restart-and-reconnect";
    sha256 = "sha256-2zwkTDLYKx04RyrtFIYFl+B9gl6H3yuZ2uKpdaVoIg4=";
  };
  buildInputs = [ pkgs.python311Packages.python ];
  dontConfigure = true;
  doUnpack = true;
  installPhase = ''
    mkdir -p $out;
    cp -r $src/* $out;
  '';
}
