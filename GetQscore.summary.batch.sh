#!/bin/sh

source ~/.bash_function
source ~/.GATKrc
	
	batch.SGE.sh Fastq.Qscore.sh `find | grep N.fastq.gz$ | sort` > 01.Fastq.Qscore
	sh 01.Fastq.Qscore

	waiting Fas
	perl -F'\t' -MMin -ane'chomp@F;$h{$F[0]}{$ARGV}=$F[1]}{mmfsn("Qscore",%h)' `find | grep N.fastq.gz.Qscore.txt$ `

	mv Qscore.txt summary


