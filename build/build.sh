#!/bin/sh
SOLUTION_TYPE=$1

if [ -n "$SOLUTION_TYPE" ]; then
    source environment.sh
    source copy_resources.sh $SOLUTION_TYPE $BUILD_TYPE
    source make.sh $SOLUTION_TYPE $BUILD_TYPE
    source install.sh $SOLUTION_TYPE $BUILD_TYPE
else
    printf "\nSolution Type is not defined"
fi
