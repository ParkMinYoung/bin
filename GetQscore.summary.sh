#!/bin/sh

source ~/.bash_function
source ~/.GATKrc

	perl -F'\t' -MMin -ane'chomp@F;$h{$F[0]}{$ARGV}=$F[1]}{mmfsn("Qscore",%h)' `find | grep N.fastq.gz.Qscore.txt$ `


