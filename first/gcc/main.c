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

    if (extension == NULL || extension == file)
    {
	return NULL;
    }

    return extension + 1;
}

static void help_print(void)
{
    FILE *file;
    int c;

    if ((file = fopen("help", "r")))
    {
	while ((c = getc(file)) != EOF)
	{
	    putchar(c);
	}

	fclose(file);
    }
}

int main(int argc, char** argv)
{
    int ret_val = -1;
    DIR* dir_stream;
    struct dirent* dir;
    struct stat st;
    const char* ext;
    char filename[PATH_MAX], new_filename[PATH_MAX], work_dir[PATH_MAX],
	new_dir[PATH_MAX], curr_dir[PATH_MAX];

    if (argc == 2)
    {
	if (strcmp(argv[1], "--help") == 0 || strcmp(argv[1], "-h") == 0)
	{
	    help_print();

	    return 0;
	}
    }

    if (getcwd(curr_dir, sizeof(curr_dir)) == NULL)
    {
	fprintf(stderr, "Failed to get current working directory\n");
	goto Exit;
    }

    if (sprintf(work_dir, "%s/%s", curr_dir, argv[1]) < 0)
    {
	fprintf(stderr, "Failed to formate working dir\n");
	goto Exit;
    }

    if (!(dir_stream = opendir(work_dir)))
    {
	fprintf(stderr, "Failed to open directory stream\n");
	goto Exit;
    }

    while ((dir = readdir(dir_stream)))
    {
	if (sprintf(filename, "%s/%s", work_dir, dir->d_name) < 0)
	{
	    fprintf(stderr, "Failed to create filename\n");
	    goto Exit;
	}

	if (!is_regular_file(filename))
	{
	    continue;
	}

	if (!(ext = extract_ext(dir->d_name)))
	{
	    continue;
	}

	if (sprintf(new_dir, "%s/%s", work_dir, ext) < 0)
	{
	    fprintf(stderr, "Failed to create move dir\n");
	    goto Exit;
	}

	if (stat(new_dir, &st) == -1)
	{
	    mkdir(new_dir, 0700);
	}

	if (sprintf(new_filename, "%s/%s", new_dir, dir->d_name) < 0)
	{
	    fprintf(stderr, "Failed to create move dir\n");
	    goto Exit;
	}

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
