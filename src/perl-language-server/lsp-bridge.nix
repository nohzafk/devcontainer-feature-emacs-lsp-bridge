{ pkgs ? import <nixpkgs> { } }:

pkgs.stdenv.mkDerivation {
  pname = "lsp-bridge-src";
  version = "20240727-devcontainer-feature";
  src = pkgs.fetchFromGitHub {
    owner = "nohzafk";
    repo = "lsp-bridge";
    rev = "567496c";
    sha256 = "sha256-qeoKPwK3qKcvUFchaQYCCQmSlXgN+Tt2kU+lXqiUwaw=";
  };
  dontConfigure = true;
  doUnpack = true;
  installPhase = ''
    mkdir -p $out;
    cp -r $src/* $out;
  '';
}
