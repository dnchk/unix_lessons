#!/usr/bin/env python

import os
import sys

def createDir(path):
    if not os.path.exists(path):
        os.mkdir(path)

def moveFile(curr, dest):
    os.rename(curr, dest)

def print_help():
    print("Usage: task.py SOURCE_DIR")
    print("Sort all the files in a SOURCE_DIR into subdirectories named by file extension")

if len(sys.argv) != 2:
    print("Usage: task.py SOURCE_DIR, see --help or -h", file=sys.stderr)
    exit(-1)

if sys.argv[1] == "-h" or sys.argv[1] == "--help":
    print_help()
    exit(0)

source_dir = sys.argv[1]

if not os.path.isdir(source_dir):
    print("Param is not a dir, see --help or -h", file=sys.stderr)
    exit(-1)

for file in os.listdir(source_dir):
    filename, file_extension = os.path.splitext(file)
    if not file_extension:
        continue

    old_path = os.path.join(source_dir, file)
    new_dir = os.path.join(source_dir, file_extension[1:])
    new_path = os.path.join(new_dir, file)

    createDir(new_dir)
    moveFile(old_path, new_path)
