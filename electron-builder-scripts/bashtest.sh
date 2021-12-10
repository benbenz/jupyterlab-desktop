#!/bin/bash

if ! egrep -q '^stata_path.*=\s*$' ~/.stata_kernel.conf; then
    echo "Stata path not empty in configuration >> wont replace"
    exit
fi


stata_exec=$(find /Applications/Stata/Stata*.app/Contents/MacOS ~/Applications/Stata/Stata*.app/Contents/MacOS -type f -name 'stata*' | egrep '^\/.*' | head -n 1)
if [ -z "$stata_exec" ]
then
    echo "search for StataIC instead"
    stata_exec=$(find /Applications/Stata/Stata*.app/Contents/MacOS ~/Applications/Stata/Stata*.app/Contents/MacOS -type f -name 'StataIC' | egrep '^\/.*' | head -n 1)
fi
## 3) Fill-in the Stata path we found
if [ ! -z "$stata_exec" ]
then
    stata_exec_esc=${stata_exec//\//\\/} # escaped Application Directory for regex replacement
    echo "Found stata path = $stata_exec"
    sed -i '.bak' "s/stata_path.*=\s*/stata_path = $stata_exec_esc/g" ~/.stata_kernel.conf
fi
