#!/usr/bin/perl

use HTML::Strip;

sub print_help {
    say STDOUT "Usage: task.pl INPUT_DATA";
    say STDOUT "Analyze the text from INPUT_DATA and select the 100 most common words";
}

sub get_cmd_arg {
    if ($#ARGV != 0) {
	print_help();
        exit 1;
    }

    if ($ARGV[0] eq "-h" or $ARGV[0] eq "--help") {
	print_help();
        exit 0;
    }

    if (not -e $ARGV[0]) {
        say STDERR "Param does not exist, see -h or --help";
        exit 1;
    }

    return $ARGV[0];
}

sub get_html {
    open(FILE, $_[0]);
    local $/;
    $doc = <FILE>;
    close(FILE);
    return $doc;
}

sub get_text_from_html {
    $hs = HTML::Strip->new();
    $text = $hs->parse($_[0]);
    $hs->eof;
    return $text;
}

$input = get_cmd_arg();
$html = get_html($input);
$text = get_text_from_html($html);

$text =~ s/\n/ /g;
$text =~ s/[[:punct:]]//g;
@words = split /\s+/, $text;

foreach $word(@words) {
    $count{$word}++;
}

@listing = (sort {$count{$b} <=> $count{$a}} keys %count)[0..100];

$file = 'out';
open($fh, '>', $file) or die "Failed to open a file";

for $word(@listing) {
    print $fh "$count{$word} $word\n";
}

close $fh;
