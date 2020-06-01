#!/usr/bin/perl

use HTML::Strip;

sub get_cmd_arg {
    $usage = "Usage: task.pl INPUT_DATA\n";

    if ($#ARGV != 0) {
        print $usage;
        exit 0;
    }

    if ($ARGV[0] eq "-h" or $ARGV[0] eq "--help") {
        print $usage;
        exit 1;
    }

    if (not -e $ARGV[0]) {
        print "Param does not exist, see -h or --help\n";
        exit 0;
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

for $word(@listing) {
    print "$word $count{$word}\n";
}
