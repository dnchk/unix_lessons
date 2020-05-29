import pathlib
import os

def getCurrentDir():
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

curr_dir = getCurrentDir()

for root, dirs, files in os.walk(curr_dir):
    for file in files:
        filename, file_extension = os.path.splitext(file)
        if file_extension != ".swp" and file_extension != ".py":
            if createDir(file_extension[1:]) == 0:
                path_new = os.path.join(root, file_extension[1:])
                moveFile(os.path.join(root, file), os.path.join(path_new, file))
