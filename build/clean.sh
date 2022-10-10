#!/bin/sh

(cd build && source environment.sh)

printf "\nRemoving temp folder..."
rm -f -r $TEMP_BUILD_DIR
printf "\nRemoving install folder..."
rm -f -r $INSTALL_DIR
