#!/usr/bin/perl

use Cwd;
use File::Copy;
use File::Basename;

sub createDir {
    if (not -e $_[0] and not -d $_[0]) {
	unless(mkdir $_[0]) {
	    print "Unable to create $_[0]\n";
	    return;
	}
    }
}

sub moveFile {
    move($_[0], $_[1]);
}

sub print_help {
    print "Usage: task.pl SOURCE_DIR\n";
    print "Sort all the files in a SOURCE_DIR into subdirectories named by file extension\n";
}

if ($#ARGV != 0) {
    print_help();
    exit 0;
}

if ($ARGV[0] eq "-h" or $ARGV[0] eq "--help") {
    print_help();
    exit 1;
}

$source_dir = $ARGV[0];

if (not -d $source_dir) {
    print "Param is not a dir, see --help or -h\n";
    exit 0;
}

opendir (DIR, $source_dir) || print "Cannot open dir: $!";
while(($file = readdir(DIR))) {
    my ($extension) = $file =~ /(\.[^.]+)$/;
    if ($extension ne "") {
	$old_path = $source_dir . "/" . $file;
	$new_dir = $source_dir . "/" . substr($extension, 1);
	$new_path = $new_dir . "/" . $file;

	createDir($new_dir);
	moveFile($old_path, $new_path);
    }
}
closedir(DIR);
