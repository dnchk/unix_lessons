#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>

#define NUM 3
#define TASK "task"

int main(int argc, char** argv)
{
    FILE** file_ptrs;
    char* test_files[] = { "dir/f.txt", "dir/f.html", "dir/f.dat" };
    char* assert_files[] = { "dir/txt/f.txt", "dir/html/f.html",
	"dir/dat/f.dat" };

    if (argc > 1 && strcmp(argv[1], "--clean") == 0)
    {
	for (int i = 0; i < NUM; ++i)
	{
	    remove(assert_files[i]);
	}

	rmdir("dir/txt");
	rmdir("dir/dat");
	rmdir("dir/html");

	return 0;
    }

    if (!(file_ptrs = malloc(sizeof(FILE*) * NUM)))
    {
	fprintf(stderr, "Allocation failed\n");
	return 1;
    }

    /* Create files for testing */
    for (int i = 0; i < NUM; ++i)
    {
	file_ptrs[i] = fopen(test_files[i], "w");
	fclose(file_ptrs[i]);
    }

    /* Run task program */
    system("./task dir");

    /* Check file existance */
    for (int i = 0; i < NUM; ++i)
    {
	if (access(assert_files[i], F_OK) != -1)
	{
	    fprintf(stdout, "Test passed\n");
	    continue;
	}

	fprintf(stdout, "Test failed\n");
    }

    return 0;
}
