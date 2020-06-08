#!/bin/bash

input="./out"

eval "javac Main.java"
eval "java Main ../input.html"

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

third_line=$(sed '3q;d' $input)

if [ "${third_line//[[:blank:]]/}" = "12Lorem" ]; then
    echo "Test passed"
else
    echo "Test failed"
fi

rm $input
