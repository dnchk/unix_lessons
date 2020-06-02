#!/bin/bash

curr_dir=$(pwd)

if [ $# -ne 1 ]; then
    echo "Usage: test.sh EXECUTABLE"
    exit 1
fi

if [ "$1" == "--clean" ] && [ -d "${curr_dir}/dir" ]; then
    rm -r "${curr_dir}/dir"
    exit 0
fi

executable=$1

work_dir="${curr_dir}/dir"
mkdir -p $work_dir;

declare -a files=("${work_dir}/q.cpp" "${work_dir}/w.html" "${work_dir}/e.dat")

for file in ${files[@]}; do
    touch $file
done

eval "./$executable dir"

for file in ${files[@]}; do
    extension=${file#*.}
    if [ -f $work_dir/$extension/$(basename -- $file) ]; then
	echo "$work_dir/$extension/$(basename -- $file): Test passed"
    fi
done
