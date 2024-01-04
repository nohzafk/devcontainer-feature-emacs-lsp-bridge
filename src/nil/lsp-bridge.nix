{ pkgs ? import <nixpkgs> { } }:

pkgs.stdenv.mkDerivation {
  pname = "lsp-bridge-src";
  version = "20240103";
  src = pkgs.fetchFromGitHub {
    owner = "nohzafk";
    repo = "lsp-bridge";
    rev = "dfc5c3210ec1d6c421ef38e51e30f568ad4a3a54";
    sha256 = "sha256-QKuOBNRGpN83d+/8rsSTRhtAP1f/oYMNEtkZuBVqlj4=";
  };
  buildInputs = [ pkgs.python311Packages.python ];
  dontConfigure = true;
  doUnpack = true;
  installPhase = ''
    mkdir -p $out;
    cp -r $src/* $out;
  '';
}
