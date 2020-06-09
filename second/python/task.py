#!/usr/bin/env python

import re
import sys
import codecs
import os.path
from collections import Counter

def print_help():
    print("Usage: task.py INPUT_DATA")
    print("Analyze the text from INPUT_DATA and select the 100 most common words")

def get_cmd_arg():
    if len(sys.argv) != 2:
        print("Usage: task.py INPUT_DATA, see -h or --help", file=sys.stderr)
        exit(-1)

    if sys.argv[1] == "-h" or sys.argv[1] == "--help":
        print_help()
        exit(0)

    if not os.path.exists(sys.argv[1]):
        print("Param is not a file, see -h or --help", file=sys.stderr)
        exit(-1)

    return sys.argv[1]

def read_html(path):
    file = codecs.open(path, "r")
    return file.read()

def get_text_from_html(raw_html):
    pattern = re.compile('<.*?>')
    return re.sub(pattern, '', raw_html)

input = get_cmd_arg()
html = read_html(input)
text = get_text_from_html(html)

top_words = Counter(text.split())

file = open("out", "w")

for key, value in top_words.most_common(100):
    line = "%d %s\n" % (value, key)
    file.write(line)

file.close()
