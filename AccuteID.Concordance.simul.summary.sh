#!/bin/sh

source ~/.bash_function
source ~/.GATKrc

	perl -F'\t' -MMin -ane'
	chomp@F;
	$ARGV =~ /(DP.+)\//;
	$h{$1}{$F[0]}=$F[3] if !/^probe/;
#$h{$F[0]}{$1}=$F[3] if !/^probe/;
	}{
			mmfsn("0.95.sample.Concordance",%h)
	' `find DP* | grep 95.sample.txt$ `
	


	perl -F'\t' -MMin -ane'
	chomp@F;
	$ARGV =~ /(DP.+)\//;
	$h{$1}{$F[0]}=$F[6] if !/^probe/;
#$h{$F[0]}{$1}=$F[6] if !/^probe/;
	}{
			mmfsn("Concordance",%h)
	' `find DP* | grep Concordance.txt$ `
	
	


