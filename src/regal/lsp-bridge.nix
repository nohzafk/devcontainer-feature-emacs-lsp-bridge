{ pkgs ? import <nixpkgs> { } }:

pkgs.stdenv.mkDerivation {
  pname = "lsp-bridge-src";
  version = "20250924";
  src = pkgs.fetchFromGitHub {
    owner = "manateelazycat";
    repo = "lsp-bridge";
    rev = "master";
    sha256 = "sha256-DGkCSWyUd/OY4KsKKX7yioHFs7ZMTuSJCXlcm+MAPr0=";
  };
  dontConfigure = true;
  doUnpack = true;
  installPhase = ''
    mkdir -p $out;
    cp -r $src/* $out;
  '';
}
