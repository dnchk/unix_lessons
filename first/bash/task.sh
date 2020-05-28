#!/bin/bash
#usage="$(basename "$0") -- program to sort all files in DIR to subdirs with name corresponding to extension of the appropriate file"
work_dir=$(pwd)
curr_file=${0##*/}
curr_file_ext=${curr_file#*.}

for file in $work_dir/*; do
    if [ ! -d $file ]; then
	extension=${file#*.}
	if [ ! -d $extension ] && [ ! $extension = $curr_file_ext ]; then
	    mkdir $extension
	fi
	if [ ! $extension = $curr_file_ext ]; then
	    mv $file $work_dir/$extension
	fi
    fi
done;
