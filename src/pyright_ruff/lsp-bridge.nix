{ pkgs ? import <nixpkgs> { } }:

pkgs.stdenv.mkDerivation {
  pname = "lsp-bridge-src";
  version = "20240105";
  src = pkgs.fetchFromGitHub {
    owner = "nohzafk";
    repo = "lsp-bridge";
    rev = "feature/user-ssh-private-key";
    sha256 = "sha256-ndM+tbTFlhJtKrzUo0Y/obsXesX5odxbgMRi4bJNRAg=";
  };
  buildInputs = [ pkgs.python311Packages.python ];
  dontConfigure = true;
  doUnpack = true;
  installPhase = ''
    mkdir -p $out;
    cp -r $src/* $out;
  '';
}
