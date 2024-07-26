{ pkgs ? import <nixpkgs> { } }:

pkgs.stdenv.mkDerivation {
  pname = "lsp-bridge-src";
  version = "20240727-devcontainer-feature";
  src = pkgs.fetchFromGitHub {
    owner = "nohzafk";
    repo = "lsp-bridge";
    rev = "e06d547";
    sha256 = "sha256-OBePqd9pZ65ZZR6vEu8MpMBcoJfjJiwFjWCTsucQSdM=";
  };
  dontConfigure = true;
  doUnpack = true;
  installPhase = ''
    mkdir -p $out;
    cp -r $src/* $out;
  '';
}
