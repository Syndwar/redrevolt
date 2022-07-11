#!/bin/sh

ENGINE_FOLDER="c:/git/stren"
BIN_FOLDER="bin"
PROJECT_FOLDER="$PWD"

read -n 1 -p "Press R for Release or D for Debug: " choice

release=false
debug=false

case $choice in
  r) release=true;;
  R) release=true;;
  d) debug=true;;
  D) debug=true;;
esac
printf "\n"
if $release; then
    (cd $ENGINE_FOLDER && source $ENGINE_FOLDER/build/make_and_install_release_x86.sh)
fi

if $debug; then
    (cd $ENGINE_FOLDER && source $ENGINE_FOLDER/build/make_and_install_debug_x86.sh)
fi

if $release || $debug; then

  printf "\nRemoving bin folder..."
  rm -f -r "$PROJECT_FOLDER/$BIN_FOLDER" 

  printf "\nCopying engine libs and executables..."
  cp -a "$ENGINE_FOLDER/.install/bin/." "$PROJECT_FOLDER/$BIN_FOLDER"
  printf "\nCopying game data..."
  cp -a "$PROJECT_FOLDER/src/maps/". "$PROJECT_FOLDER/$BIN_FOLDER/maps"
  cp -a "$PROJECT_FOLDER/src/base/". "$PROJECT_FOLDER/$BIN_FOLDER/base"
fi
