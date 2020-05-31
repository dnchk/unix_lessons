#!/bin/bash

usage="Usage: task.sh SOURCE_DIR"

if [ $# -ne 1 ]; then
    echo $usage
    exit 1
fi

if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    echo $usage
    exit 0
fi

source_dir=$1
if [ ! -d $source_dir ]; then
    echo "Param is not a dir, see --help or -h"
    exit 1
fi

for file in $source_dir/*; do
    if [ ! -d $file ]; then
	extension=${file#*.}
	if [ ! -d $source_dir/$extension ]; then
	    mkdir $source_dir/$extension
	fi

	file_base=${file##*/}
	mv $file $source_dir/$extension/$file_base
    fi
done;
