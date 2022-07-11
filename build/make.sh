#!/bin/sh
SOLUTION_TYPE=$1
BUILD_TYPE=$2

OUTPUT_PATH=$TEMP_BUILD_DIR/$BUILD_TYPE

(cd .. && cmake -G "$COMPILER" -A "$BUILD_TYPE" -S . -B "$OUTPUT_PATH")
(cd .. && cmake --build "$OUTPUT_PATH" --config "$SOLUTION_TYPE")
