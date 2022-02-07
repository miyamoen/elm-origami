{ pkgs ? import (import ./nix/sources.nix).nixpkgs { } }:

pkgs.mkShell {
  packages = [
    pkgs.elmPackages.elm
    pkgs.elmPackages.elm-test
    pkgs.elmPackages.elm-format
    pkgs.elmPackages.elm-review
    pkgs.elmPackages.elm-json
    pkgs.elmPackages.elm-doc-preview
  ];

  inputsFrom = [ ];

  shellHook = "";
}
