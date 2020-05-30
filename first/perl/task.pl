#!/usr/bin/perl

use Cwd;
use File::Copy;
use File::Basename;

sub getCurrentDir {
    return Cwd::cwd();
}

sub createDir {
    if (not -e $_[0] and not -d $_[0]) {
	unless(mkdir $_[0]) {
	    print "Unable to create $_[0]\n";
	    return;
	}
	print "$_[0] created\n";
    }
    else {
	print "$_[0] already exists\n";
    }
}

sub moveFile {
    move($_[0], $_[1]);
}

$usage = "Usage: task.pl SOURCE_DIR\n";

if ($#ARGV != 0) {
    print $usage;
    exit 0;
}

if ($ARGV[0] eq "-h" or $ARGV[0] eq "--help") {
    print $usage;
    exit 1;
}

$source_dir = $ARGV[0];

if (not -e $source_dir and not -d $source_dir) {
    print "Param is not a dir, see --help or -h\n";
    exit 0;
}

$curr_path = getCurrentDir();

opendir (DIR, $source_dir) || print "Cannot open dir: $!";
while(($file = readdir(DIR))) {
    my ($extension) = $file =~ /(\.[^.]+)$/;
    if ($extension ne "") {
	$old_path = $curr_path . "/" . $source_dir . "/" . $file;
	$new_dir = $source_dir . "/" . substr($extension, 1);
	$new_path = $curr_path . "/" . $new_dir . "/" . $file;

	createDir($new_dir);
	moveFile($old_path, $new_path);
    }
}
closedir(DIR);
