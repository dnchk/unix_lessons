#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <dirent.h>
#include <sys/stat.h>
#include <unistd.h>

static int is_regular_file(const char* path)
{
    struct stat path_stat;
    stat(path, &path_stat);
    return S_ISREG(path_stat.st_mode);
}

#define DELIM '.'
static const char* extract_ext(const char* file)
{
    const char* extension = strrchr(file, DELIM);

    if (extension == NULL)
    {
	return NULL;
    }

    return extension + 1;
}

static void help_print(void)
{
    printf("Usage: task [SOURCE_DIR]\n");
    printf("Sort all files in SOURCE_DIR to subdirs with name corresponding to extension of the appropriate file.\n");
}

#define CHECK_SPRINTF(expr) if ((expr) < 0) { \
			fprintf(stderr, "Failed sprintf conversion\n"); \
			goto Exit; \
		    }

int main(int argc, char** argv)
{
    int ret_val = -1;
    DIR* dir_stream;
    struct dirent* dir;
    struct stat st;
    const char *ext, *work_dir = argv[1];
    char filename[PATH_MAX], new_filename[PATH_MAX], new_dir[PATH_MAX];

    if (argc == 2)
    {
	if (strcmp(argv[1], "--help") == 0 || strcmp(argv[1], "-h") == 0)
	{
	    help_print();

	    return 0;
	}
    }

    if ((dir_stream = opendir(work_dir)) == NULL)
    {
	fprintf(stderr, "Failed to open directory stream\n");
	goto Exit;
    }

    while ((dir = readdir(dir_stream)))
    {
	CHECK_SPRINTF(sprintf(filename, "%s/%s", work_dir, dir->d_name));

	if (!is_regular_file(filename) || !(ext = extract_ext(dir->d_name)))
	{
	    continue;
	}

	CHECK_SPRINTF(sprintf(new_dir, "%s/%s", work_dir, ext));

	if (stat(new_dir, &st) == -1)
	{
	    mkdir(new_dir, 0700);
	}

	CHECK_SPRINTF(sprintf(new_filename, "%s/%s", new_dir, dir->d_name));

	if (rename(filename, new_filename) != 0)
	{
	    fprintf(stderr, "Failed to rename file\n");
	    goto Exit;
	}
    }

    ret_val = 0;

Exit:
    closedir(dir_stream);

    return ret_val;
}
