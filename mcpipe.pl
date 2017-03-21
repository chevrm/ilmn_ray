#!/bin/env perl

use strict;
use warnings;
use Cwd 'abs_path';

## usage:  perl mcpipe.pl FWD.fq REV.fq prefix

my $k = 31;
my $threads = 38;

## Setup script path
my $script_dir = abs_path($0);
$script_dir =~ s/\/mcpipe\.pl//;

## Parse args
my ($fwd, $rev, $pref) = (shift, shift, shift);

## Musket
system("musket -p $threads -inorder -omulti $pref.musket -k $k 536870912 $fwd $rev");
system("mv $pref.musket.0 $pref.musket.0.fastq");
system("mv $pref.musket.1 $pref.musket.1.fastq");

## Flash pairs
system("flash -t $threads -o $pref $pref.musket.0.fastq $pref.musket.1.fastq");

## Ray
system("mpiexec -c $threads Ray -k $k -o $pref-ray-$k " .
	"-disable-scaffolder -disable-network-test " .
	"-s $pref.extendedFrags.fastq -p $pref.notCombined_1.fastq " .
	"$pref.notCombined_2.fastq < /dev/null " .
	"1> $pref.ray-$k.out 2> $pref.ray-$k.err");
