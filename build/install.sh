#!/bin/sh

SOLUTION_TYPE=$1
OUTPUT_PATH=$TEMP_BUILD_DIR/$BUILD_TYPE

(cd .. && cmake --install "$OUTPUT_PATH" --prefix "$PWD/$INSTALL_DIR" --config "$SOLUTION_TYPE")
