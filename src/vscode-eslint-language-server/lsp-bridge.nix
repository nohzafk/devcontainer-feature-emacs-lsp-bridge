{ pkgs ? import <nixpkgs> { } }:

pkgs.stdenv.mkDerivation {
  pname = "lsp-bridge-src";
  version = "20240609-master";
  src = pkgs.fetchFromGitHub {
    owner = "manateelazycat";
    repo = "lsp-bridge";
    rev = "d4e3534";
    sha256 = "sha256-M7bThgIc/EzmlffmkLzwWCLHXS4aBVLem5FuPiWXaTE=";
  };
  buildInputs = [ pkgs.python311Packages.python ];
  dontConfigure = true;
  doUnpack = true;
  installPhase = ''
    mkdir -p $out;
    cp -r $src/* $out;
  '';
}
