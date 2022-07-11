#!/bin/sh

printf "\nRemoving temp folder..."
(cd .. && rm -f -r $TEMP_BUILD_DIR)
printf "\nRemoving install folder..."
(cd .. && rm -f -r $INSTALL_DIR)
printf "\nRemoving binaries..."
(cd .. && rm -f -r lib)
(cd .. && rm -f -r include)
