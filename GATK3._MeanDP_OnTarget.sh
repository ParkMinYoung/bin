#!/bin/bash

. ~/.bash_function

if [ $# -eq 3 ];then

		# 1 Target dir
		# 2 seq 10 10 100
		# 3 target interval size

		target_dir=$1
		span_dir=span_$2
		size=$3

		mkdir $span_dir
		cd $span_dir
		cu=$PWD

		cd $target_dir
		ln -s $PWD/sample*.data $cu
		cd $cu

		join.h.sh samples.dedup_metrics.data samples.aligned.data 1 1 2..6 > step1
		join.h.sh step1 samples.depthofcov.proportions.subset.data 1 1 2..9 > step2

		perl -F'\t' -MMin -asnle'if($.==1){print "$_\tMeanDP\tOnTargetRate"}else{$DP=round($F[14]/$size,2); $onTargetRate= percent($F[14]/$F[12],2); @F[3,10,17..24] = map { percent($_,2) } @F[3,10,17..24]; print join "\t", @F, $DP, $onTargetRate }' -- -size=$size step2 > step3

else
	usage "Target_DIR 10 123456"	
fi

