#!/bin/sh

cd .
source build/environment.sh
printf "\nRemoving temp folder..."
rm -f -r $TEMP_BUILD_DIR
printf "\nRemoving install folder..."
rm -f -r $INSTALL_DIR
printf "\nRemoving binaries..."
rm -f -r bin
rm -f -r libs
rm -f -r include
