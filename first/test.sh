#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: test.sh EXECUTABLE"
    exit 1
fi

executable=$1
work_dir=$(mktemp -d -t workdir-XXXXXXXX)
trap "rm -rf $work_dir" EXIT

declare -a files=("${work_dir}/q.cpp" "${work_dir}/w.html" "${work_dir}/e.dat")

for file in ${files[@]}; do
    touch $file
done

eval ./$executable '${work_dir}'

for file in ${files[@]}; do
    extension=${file#*.}
    if [ ! -f $work_dir/$extension/$(basename -- $file) ]; then
	echo "Test failed"
	exit 1
    fi
done
echo "Test passed"
