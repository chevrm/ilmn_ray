#!/bin/env perl

use strict;
use warnings;

## usage:
##	perl trimmomatic.pl FWD.fastq REV.fastq <adapter.fa>

my $trim = '/home/mchevrette/downloads/Trimmomatic-0.33/trimmomatic-0.33.jar';
my ($f, $r, $a) = (shift, shift, shift);
my @ff = split(/\//, $f);
my @rf = split(/\//, $r);
my ($fpref, $rpref) = ($ff[-1], $rf[-1]);
$fpref =~ s/\.fastq//;
$rpref =~ s/\.fastq//;
my $both = $fpref;
$both =~ s/_R\d//;
$both =~ s/musket\.\d/musket/;
my $cmd = "java -jar $trim PE -phred33 $f $r " .
	"$fpref.trimpair.fastq $fpref.trimunpair.fastq " .
	"$rpref.trimpair.fastq $rpref.trimunpair.fastq ";
$cmd .= "ILLUMINACLIP:tmpartifacts.fa:2:30:10 LEADING:3 TRAILING:3 " if($a);
$cmd .= "SLIDINGWINDOW:4:15 MINLEN:36";
system("$cmd");
system("cat $fpref.trimunpair.fastq $rpref.trimunpair.fastq > $both.trimunpairboth.fastq");
