import os
import sys
import pathlib

def gerCurrentDir():
    return os.getcwd()

def createDir(path):
    if not os.path.exists(path):
        os.mkdir(path)
        print("Directory", path, "created")
    else:
        print("Directory", path, "already exists")

def moveFile(curr, dest):
    os.rename(curr, dest)

usage = "Usage: task.py SOURCE_DIR"

if len(sys.argv) != 2:
    print(usage)
    exit(-1)

if sys.argv[1] == "-h" or sys.argv[1] == "--help":
    print(usage)
    exit(0)

source_dir = sys.argv[1]

if not os.path.isdir(source_dir):
    print("Param is not a dir, see --help or -h")
    exit(-1)

curr_path = gerCurrentDir()

for file in os.listdir(source_dir):
    filename, file_extension = os.path.splitext(file)
    if not file_extension:
        continue

    old_path = os.path.join(curr_path, source_dir, file)
    new_dir = os.path.join(source_dir, file_extension[1:])
    new_path = os.path.join(curr_path, new_dir, file)

    createDir(new_dir)
    moveFile(old_path, new_path)
