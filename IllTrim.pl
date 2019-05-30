#!/usr/bin/perl -w

# AUTHOR: Joseph Fass
# LAST REVISED: August 2009
# 
# The Bioinformatics Core at UC Davis Genome Center
# http://bioinformatics.ucdavis.edu
# Copyright (c) 2009 The Regents of University of California, Davis Campus.
# All rights reserved.

# illTrim.pl does simplistic trimming of Illumina sequences ... chops the 3' end at the 1st "poor" quality base
# NOTE: this script *will* print empty sequences when the first base is below the threshold ...
#  but there will be a newline in the sequence and quality lines

while ($h1 = <>) {
	$s = <>;
	$h2 = <>;
	$q = <>;
	chomp $q;
	if (ord(substr($q,0,1)) - 64 >= 20) {
		$good = 1;
		while ( ord(substr($q,$good,1)) - 64 >= 20 ) {
			$good++;
		}
		print "$h1";
		print substr($s,0,$good);
		print "\n$h2";
		print substr($q,0,$good);
		print "\n";
	}
}

