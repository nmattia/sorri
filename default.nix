{
  pkgs ? import <nixpkgs> {},
  ...
}:

pkgs.writeScriptBin "sorri" ''
  #!${pkgs.bash}/bin/bash

  if [ "$1" != "init" ]; then
    echo "usage: sorri init"
  elif [ -e .envrc ]; then
    echo ".envrc already exists. Remove it first."
  else
    mkdir -p nix
    cp ${./sorri} nix/sorri
    echo ". nix/sorri $(basename $PWD)" > .envrc
    direnv allow
  fi
''
