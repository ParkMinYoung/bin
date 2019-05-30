#!/bin/bash

. ~/.bash_function

if [ -f "$1" ];then


		# execute time : 2018-07-10 14:42:34 : make plink
		VCF2PLINK.sh $1 


		# execute time : 2018-07-10 14:43:50 : pairwise concordant rate
		PairwiseCalcConcordantRateFromPlink.sh $1.plink.binary


		mv $1.plink.* simulation

else	
		usage "XXX.vcf"
fi

