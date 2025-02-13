{ pkgs ? import <nixpkgs> { } }:

pkgs.stdenv.mkDerivation {
  pname = "lsp-bridge-src";
  version = "20250213";
  src = pkgs.fetchFromGitHub {
    owner = "manateelazycat";
    repo = "lsp-bridge";
    rev = "master";
    sha256 = "sha256-lWbFbYwJoy4UAezKUK7rnjQlDcnszHQwK5I7fuHfE8Y=";
  };
  dontConfigure = true;
  doUnpack = true;
  installPhase = ''
    mkdir -p $out;
    cp -r $src/* $out;
  '';
}
