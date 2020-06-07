#!/bin/bash

print_help() {
    echo "Usage: task.sh INPUT_DATA"
    echo "Analyze the text from INPUT_DATA and select the 100 most common words"
}

if [ $# -ne 1 ]; then
    print_help
    exit 1
fi

if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    print_help
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

