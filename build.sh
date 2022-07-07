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

if $release; then
  source $ENGINE_FOLDER/build/make_and_install_release_x86.sh	
fi

if $debug; then
  source $ENGINE_FOLDER/build/make_and_install_debug_x86.sh
fi

if $release || $debug; then
  cd $ENGINE_FOLDER

  printf "\nRemoving bin folder..."
  rm -f -r "$PROJECT_FOLDER/$BIN_FOLDER" 

  printf "\nCopying engine libs and executables..."
  cp -r "$ENGINE_FOLDER/.install/bin" "$PROJECT_FOLDER/$BIN_FOLDER"
  printf "\nCopying game data..."
  cp -r "$PROJECT_FOLDER/src" "$PROJECT_FOLDER/$BIN_FOLDER"

  cd $PROJECT_FOLDER
fi
