# Filename: ghdl.sh
# Author: Nikolaos Kavvadias (C) 2016-2021

#!/bin/bash

make -if ghdl.mk clean
make -if ghdl.mk init
make -if ghdl.mk run

if [ "$SECONDS" -eq 1 ]
then
  units=second
else
  units=seconds
fi
echo "This script has been running for $SECONDS $units."
