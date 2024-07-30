{ pkgs ? import <nixpkgs> { } }:

pkgs.stdenv.mkDerivation {
  pname = "lsp-bridge-src";
  version = "20240730-devcontainer-feature";
  src = pkgs.fetchFromGitHub {
    owner = "nohzafk";
    repo = "lsp-bridge";
    rev = "b9e6130";
    sha256 = "sha256-RagsXHip0gxqsN43hbq8l7WOACd5BrS9i/uuSKsej18=";
  };
  dontConfigure = true;
  doUnpack = true;
  installPhase = ''
    mkdir -p $out;
    cp -r $src/* $out;
  '';
}
