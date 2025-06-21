{ pkgs ? import <nixpkgs> { } }:

pkgs.stdenv.mkDerivation {
  pname = "lsp-bridge-src";
  version = "20250621";
  src = pkgs.fetchFromGitHub {
    owner = "manateelazycat";
    repo = "lsp-bridge";
    rev = "master";
    sha256 = "sha256-dXqr3nWK9rsDK0Tbe3aoljNE3xKjLShTovYs3rebKgs=";
  };
  dontConfigure = true;
  doUnpack = true;
  installPhase = ''
    mkdir -p $out;
    cp -r $src/* $out;
  '';
}
