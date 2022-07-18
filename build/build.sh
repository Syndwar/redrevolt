#!/bin/sh
SOLUTION_TYPE=$1

if [ -n "$SOLUTION_TYPE" ]; then
    source environment.sh;
    if !(source make.sh $SOLUTION_TYPE $BUILD_TYPE); then
        exit 1
    fi
    if !(source install.sh $SOLUTION_TYPE $BUILD_TYPE); then
        exit 1
    fi
    if !(source copy_resources.sh $SOLUTION_TYPE $BUILD_TYPE); then
        exit 1
    fi
else
    printf "\nSolution Type is not defined"
fi
