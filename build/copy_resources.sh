#!/bin/sh

PROJECT_PATH="$PWD/../"

printf "Copy binaries...\n"
cp -a "$PROJECT_PATH/$INSTALL_DIR/$BIN_DIR/." "$PROJECT_PATH/$BIN_DIR"
