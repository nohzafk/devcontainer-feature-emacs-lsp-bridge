{ pkgs ? import <nixpkgs> { } }:

pkgs.stdenv.mkDerivation {
  pname = "lsp-bridge-src";
  version = "20260322";
  src = pkgs.fetchFromGitHub {
    owner = "manateelazycat";
    repo = "lsp-bridge";
    rev = "master";
    sha256 = "sha256-OiE5UHKd2j9itpSw6wiQahyBEixUPnNoIppYoHq2FCs=";
  };
  dontConfigure = true;
  doUnpack = true;
  installPhase = ''
    mkdir -p $out;
    cp -r $src/* $out;
  '';
}
