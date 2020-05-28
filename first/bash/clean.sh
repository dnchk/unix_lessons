#!/bin/bash
curr_dir=$(pwd)

for file in $curr_dir/*; do
    if [ -d $file ]; then
	rm -r $file
    fi
done;
