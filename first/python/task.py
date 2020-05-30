import os
import sys
import pathlib

def gerCurrentDir():
    return os.getcwd()

def createDir(path):
    if not os.path.exists(path):
        os.mkdir(path)
        print("Directory", path, "created")
        return 0
    else:
        print("Directory", path, "already exists")
        return -1

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

for root, dirs, files in os.walk(source_dir):
    for file in files:
        filename, file_extension = os.path.splitext(file)

        if file_extension != ".swp" and file_extension != ".py":
            if createDir(source_dir + "/" + file_extension[1:]) == -1:
                continue

            curr_dir = gerCurrentDir()
            path_new = os.path.join(root, file_extension[1:])
            whole_path_old = curr_dir + "/" + os.path.join(root, file)
            whole_path_new = curr_dir + "/" + path_new + "/" + file
            moveFile(whole_path_old, whole_path_new)
