#!/bin/env perl

use strict;
use warnings;

my $lead = 'AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC';
my $tail = 'ATCTCGTATGCCGTCTTCTGCTTG';

while(my $fn = shift){
	my $hex = $fn;
	$hex =~ s/.+_([ACGT]{6})_.+/$1/;
	my $art = $lead . $hex . $tail;
	print '>' . "$fn\n$art\n";
}
