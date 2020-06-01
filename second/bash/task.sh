#!/bin/bash

usage="Usage: task.sh INPUT_DATA"

if [ $# -ne 1 ]; then
    echo $usage
    exit 1
fi

if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    echo $usage
    exit 0
fi

input=$1
if [ ! -f $input ]; then
    echo "Param is not a file, see --help or -h"
    exit 1
fi

html=$(<$input)
text=$(sed 's/<[^>]*>//g' <<< "$html")
clean_text=$(sed -e 's/\([[:punct:]]\)//g' <<< "$text")

echo $clean_text

