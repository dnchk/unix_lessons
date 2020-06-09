#!/usr/bin/perl

use Cwd;
use File::Copy;
use File::Basename;

sub createDir {
    if (not -e $_[0]) {
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
    say STDOUT "Usage: task.pl SOURCE_DIR";
    say STDOUT "Sort all the files in a SOURCE_DIR into subdirectories named by file extension";
}

if ($#ARGV != 0) {
    say STDERR "Usage: task.pl SOURCE_DIR, see -h or --help";
    exit 1;
}

if ($ARGV[0] eq "-h" or $ARGV[0] eq "--help") {
    print_help();
    exit 0;
}

$source_dir = $ARGV[0];

if (not -d $source_dir) {
    say STDERR "Param is not a dir, see --help or -h";
    exit 1;
}

opendir (DIR, $source_dir) || say STDERR "Cannot open dir: $!";
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
