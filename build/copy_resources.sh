#!/bin/sh

PROJECT_PATH="$PWD/../"
ENGINE_PATH=$PROJECT_PATH/$ENGINE_DIR
ENGINE_INCLUDE_PATH="$ENGINE_PATH/$ENGINE_INSTALL_DIR/include"
ENGINE_BIN_PATH="$ENGINE_PATH/$ENGINE_INSTALL_DIR/$ENGINE_BIN_DIR"
PROJECT_INSTALL_PATH="$PROJECT_PATH/$INSTALL_DIR"
PROJECT_INCLUDE_PATH="$PROJECT_PATH/include"

(cd $ENGINE_PATH/build && source build.sh $SOLUTION_TYPE)

printf "\nCleaning project folder..."
source clean.sh

printf "\nCopying engine binaries..."
cp -a "$ENGINE_BIN_PATH/." "$PROJECT_INSTALL_PATH"

printf "\nCopying engine includes..."
mkdir -p "$PROJECT_INCLUDE_PATH"
cp -a "$ENGINE_INCLUDE_PATH/stren/" "$PROJECT_INCLUDE_PATH"
cp -a "$ENGINE_INCLUDE_PATH/SDL2/" "$PROJECT_INCLUDE_PATH"
printf "\nCopying engine libs..."
cp -a "$ENGINE_PATH/$ENGINE_INSTALL_DIR/lib/" "$PROJECT_PATH"

printf "\nCopying game resources..."
cp -a "$PROJECT_PATH/$RES_DIR/." "$PROJECT_INSTALL_PATH"
