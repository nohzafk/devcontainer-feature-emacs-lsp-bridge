{ pkgs ? import <nixpkgs> { } }:

pkgs.stdenv.mkDerivation {
  pname = "lsp-bridge-src";
  version = "20250525";
  src = pkgs.fetchFromGitHub {
    owner = "manateelazycat";
    repo = "lsp-bridge";
    rev = "master";
    sha256 = "sha256-Fh3KrNF7ki7h+bTRI2MaUsjrenIRCTLQmoq853fHqDk=";
  };
  dontConfigure = true;
  doUnpack = true;
  installPhase = ''
    mkdir -p $out;
    cp -r $src/* $out;
  '';
}
