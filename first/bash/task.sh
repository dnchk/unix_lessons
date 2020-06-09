#!/bin/bash

echoerr() {
    echo "$0" 1>&2;
}

print_help() {
    echo "Usage: task.sh SOURCE_DIR"
    echo "Group all the files in a SOURCE_DIR into subdirectories by file extension"
}

if [ $# -ne 1 ]; then
    print_help
    echoerr "Usage: task.sh SOURCE_DIR, see --help or -h"
    exit 1
fi

if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    print_help
    exit 0
fi

source_dir=$1
if [ ! -d $source_dir ]; then
    echoerr "Param is not a dir, see --help or -h"
    exit 1
fi

for file in $source_dir/*; do
    if [ -f $file ]; then
	extension=${file#*.}
	if [ ! -d $source_dir/$extension ]; then
	    mkdir $source_dir/$extension
	fi

	file_base=${file##*/}
	mv $file $source_dir/$extension/$file_base
    fi
done;
