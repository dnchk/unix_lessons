#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: test.sh EXECUTABLE"
    exit 1
fi

input="./out"
executable=$1

eval ./$executable 'input.html'

first_line=$(sed '1q;d' $input)

if [ "${first_line//[[:blank:]]/}" = "15the" ]; then
    echo "Test passed"
else
    echo "Test failed"
fi

second_line=$(sed '2q;d' $input)

if [ "${second_line//[[:blank:]]/}" = "13of" ]; then
    echo "Test passed"
else
    echo "Test failed"
fi

fifth_line=$(sed '5q;d' $input)

if [ "${fifth_line//[[:blank:]]/}" = "10a" ]; then
    echo "Test passed"
else
    echo "Test failed"
fi

rm $input
