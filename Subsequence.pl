#!/usr/bin/perl -w

# AUTHOR: Joseph Fass
# LAST REVISED: June 2008
# 
# The Bioinformatics Core at UC Davis Genome Center
# http://bioinformatics.ucdavis.edu
# Copyright (c) 2008 The Regents of University of California, Davis Campus.
# All rights reserved.

use strict;

my $usage = "usage: $0 <input file (fasta/q format)> <1-based first base position> <1-based last base position>\n";
my $filename = shift or die $usage;
my $first = shift or die $usage;
my $last = shift or die $usage;

print "WARNING: only works *correctly* for sequences (and header lines) on one line ... \n".
	  "... in addition, qualities must be single-character (not numbers). \n\n";

open IN, "<$filename";
my $outfilename = "$filename" . ".pos$first" . 'to' . "$last";
$first--; $last--; # shift to zero-indexed positions
open OUT, ">$outfilename";
my $line; my $sub;
while (<IN>) {
	if (m/^>/) { # fasta header
		print OUT;
		$line = (<IN>); # read next (sequence) line
		$sub = substr($line,$first,$last-$first+1);
		print OUT $sub."\n";
	} # if-fasta
	if (m/^@/) { # fastq sequence header
		print OUT;
		$line = (<IN>); # read next (sequence) line
		$sub = substr($line,$first,$last-$first+1);
		print OUT $sub."\n";
		$line = (<IN>); # read next (fastq qual header) line
		print OUT $line;
		$line = (<IN>); # read next (qaulity) line
		$sub = substr($line,$first,$last-$first+1);
		print OUT $sub."\n";
	} # if-fastq
} # while
close IN;
close OUT;
