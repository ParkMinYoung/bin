#!/bin/bash

. ~/.bash_function


if [ -f "$1" ] && [ -f "$2" ];then

	VCF=$(readlink -f $1)
	PAIR=$(readlink -f $2)
	DIR=${3:-"SimResultByPair"}

	[ ! -d "$DIR" ] && mkdir $DIR

	cd $DIR

	while IFS=$'\t' read -r A B C; do

		ID="$A,$B"
		vcftools.extract.sample.sh $VCF "$ID" 0 0  
		
		VCF_sub=$A.recode.vcf
		echo "VCF.self.GQ.DQ.simulation.concordance.sh $VCF_sub $A &"
		#VCF.self.GQ.DQ.simulation.concordance.sh $VCF_sub $ID

	done < $PAIR > script

	sh script 

	AddRow.w.sh ConcordantRate '(.+)\/plinkMerge' ID */plinkMerge/ConcordantRate | grep ^AddRow | sh
	
	## make Report
	\cp -f /home/adminrig/src/short_read_assembly/bin/R/Report/ConcordantRate_Simulation_DP_GQ.Rmd ./ && ssh -q -x 211.174.205.69 "cd $PWD && run.RMD.sh ConcordantRate_Simulation_DP_GQ.Rmd"


else
	usage "VCF Pairs [OUTPUT_DIR]"
fi

