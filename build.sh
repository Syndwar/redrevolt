#!/bin/sh

ENGINE_FOLDER="c:/git/stren"
BIN_FOLDER="bin"
PROJECT_FOLDER="$PWD"
INSTALL_FOLDER=".install"
ENGINE_INCLUDE_FOLDER="$ENGINE_FOLDER/$INSTALL_FOLDER/include"
ENGINE_BIN_FOLDER="$ENGINE_FOLDER/$INSTALL_FOLDER/$BIN_FOLDER"
PROJECT_BIN_FOLDER="$PROJECT_FOLDER/$BIN_FOLDER"
PROJECT_INCLUDE_FOLDER="$PROJECT_FOLDER/include"

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

  printf "\nCleaning project folder..."
  source build/clean.sh

  printf "\nCopying engine libs and executables..."
  cp -a "$ENGINE_BIN_FOLDER/." "$PROJECT_BIN_FOLDER"

  mkdir -p "$PROJECT_INCLUDE_FOLDER"
  cp -a "$ENGINE_INCLUDE_FOLDER/stren/" "$PROJECT_INCLUDE_FOLDER/stren"
  cp -a "$ENGINE_INCLUDE_FOLDER/SDL2/" "$PROJECT_INCLUDE_FOLDER/SDL2"
  cp -a "$ENGINE_FOLDER/$INSTALL_FOLDER/lib/." "$PROJECT_FOLDER/libs"

  printf "\nCopying game data..."
  cp -a "$PROJECT_FOLDER/src/maps/". "$PROJECT_BIN_FOLDER/maps"
  cp -a "$PROJECT_FOLDER/src/base/". "$PROJECT_BIN_FOLDER/base"
fi

if $release; then
    source build/make_and_install_release_x86.sh
fi

if $debug; then
    source build/make_and_install_debug_x86.sh
fi


