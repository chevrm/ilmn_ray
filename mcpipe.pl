#!/bin/env perl

use strict;
use warnings;
use Cwd 'abs_path';

## usage:  perl mcpipe.pl FWD.fq REV.fq prefix

my $threads = 38;

## Setup script path
my $script_dir = abs_path($0);
$script_dir =~ s/\/mcpipe\.pl//;

## Parse args
my ($fwd, $rev, $pref) = (shift, shift, shift);

## Get adapter seqs
system("perl $script_dir/ilmnartifactfa.pl $fwd $rev > tmpartifacts.fa");

## Musket
system("musket -p $threads -inorder -omulti $pref.musket -k 31 536870912 $fwd $rev");
system("mv $pref.musket.0 $pref.musket.0.fastq");
system("mv $pref.musket.1 $pref.musket.1.fastq");

## Trim
system("perl $script_dir/trimmomatic.pl $pref.musket.0.fastq $pref.musket.1.fastq tmpartifacts.fa");

## Flash pairs
system("flash -t $threads -o $pref.tp $pref.musket.0.trimpair.fastq $pref.musket.1.trimpair.fastq");

## Ray
system("mpiexec -c $threads Ray -k 31 -o $pref-ray-31 " .
	"-disable-scaffolder -disable-network-test " .
	"-s $pref.tp.extendedFrags.fastq -p $pref.tp.notCombined_1.fastq " .
	"$pref.tp.notCombined_2.fastq -s $pref.musket.0.trimunpair.fastq " .
	"-s $pref.musket.1.trimunpair.fastq < /dev/null " .
	"1> $pref.ray-31.out 2> $pref.ray-31.err");
