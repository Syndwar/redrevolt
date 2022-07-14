#!/bin/sh

BUILD_TYPE=$1

if [ "$BUILD_TYPE" = "Debug" ]; then
    cd ..
    cd bin
    ./redrevoltd.exe
    cd ..
    cd build

elif [ "$BUILD_TYPE" = "Release" ]; then 
    cd ..
    cd bin
    ./redrevolt.exe
    cd ..
    cd build
fi
