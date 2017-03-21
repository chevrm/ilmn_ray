#!/bin/env perl

use strict;
use warnings;

my $pipedir = '~/git/ilmn_ray';

my %p = ();
my @stage = glob("stage/*.fastq");
foreach my $file (@stage){
	my $sid = $file;
	$sid =~ s/stage\/(\d+)_.+/$1/;
	$sid = 'SID' . $sid;
	if($file =~ m/R1/){
		$p{$sid}{'left'} = $file;
	}elsif($file =~ m/R2/){
		$p{$sid}{'right'} = $file;
	}
}
foreach my $s (keys %p){
	system("perl $pipedir/mcpipe.pl $p{$s}{'left'} $p{$s}{'right'} $s");
}
