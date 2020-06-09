#!/bin/bash

echoerr() {
    echo "$0" 1>&2;
}

print_help() {
    echo "Usage: task.sh INPUT_DATA"
    echo "Analyze the text from INPUT_DATA and select the 100 most common words"
}

if [ $# -ne 1 ]; then
    echoerr "Usage: task.sh INPUT_DATA, see -h or --help"
    exit 1
fi

if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    print_help
    exit 0
fi

input=$1
if [ ! -f $input ]; then
    echoerr "Param is not a file, see --help or -h"
    exit 1
fi

sed 's/<[^>]*>//g; s/\([[:punct:]]\)//g' $input \
    | tr '[:space:]' '[\n*]' | grep -v "^\s*$" | sort \
    | uniq -c | sort -bnr | head -n 100 > out
