import re
import sys
import codecs
import os.path
from collections import Counter

def get_cmd_arg():
    usage = "Usage: task.py INPUT_DATA"

    if len(sys.argv) != 2:
        print(usage)
        exit(-1)

    if sys.argv[1] == "-h" or sys.argv[1] == "--help":
        print(usage)
        exit(0)

    if not os.path.exists(sys.argv[1]):
        print("Param is not a file, see -h or --help")
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

top_words = Counter(text.split()).most_common(100)
print(top_words)
