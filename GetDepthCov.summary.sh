#!/bin/sh

source ~/.bash_function
source ~/.GATKrc

	perl -F'\t' -MMin -ane'chomp@F;$h{$F[0]}{$ARGV}=$F[1]}{mmfsn("DepthCoverage",%h)' `find | grep hist.DepthPer.txt$ `


