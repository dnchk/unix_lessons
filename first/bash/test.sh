#!/bin/bash
work_dir=$(pwd)
declare -a files=("f.c" "f.dat" "f.html")

for file in ${files[@]}; do
    touch $file
done

sh ./task.sh

for file in ${files[@]}; do
    extension=${file#*.}
    if [ -f $work_dir/$extension/$file ]; then
	echo "$work_dir/$extension/$f: Test passed"
    fi
done
