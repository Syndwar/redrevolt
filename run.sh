#!/bin/sh

read -n 1 -p "Press R for Release or D for Debug: " choice

release=false
debug=false

case $choice in
  r) release=true;;
  R) release=true;;
  d) debug=true;;
  D) debug=true;;
esac
printf "\n"

if $release; then
    (cd bin && ./stren.exe)
fi

if $debug; then
    (cd bin && ./strend.exe) 
fi
