#!/bin/bash

. ~/.bash_function
. ~/.minyoungrc


if [ -d "$1" ];then


		RUN_DIR=$1
		CSV=$2
		OPTIONS="$3"
		REF=${4:-$LR_b37_ref}


		BATCH=$( echo $RUN_DIR | grep -o -P B\\w+ | sed 's/^B//' )
		FASTQ_DIR=$BATCH/outs/fastq_path/$BATCH

		# execute time : 2019-04-29 11:22:14 : run
		10xG_run_mkfastq.sh $RUN_DIR $CSV


		#SAMPLES=$( find $FASTQ_DIR  | grep I1_001.fastq.gz$ | xargs -n 1 -i dirname {} | xargs -n 1 -i basename {} | tr "\n" " " | sed 's/ $//' | tr " " "," )
		# execute time : 2019-04-29 11:22:14 : get samples list by seperating comma
		SAMPLES=$( find $FASTQ_DIR  | grep I1_001.fastq.gz$ | xargs -n 1 -i dirname {} | xargs -n 1 -i basename {} )


		for i in $SAMPLES;
			
			do 
			10xG_run_wgs.sh DL_$i $i $FASTQ_DIR "$OPTIONS" $REF

		done

else

		usage "Run_Dir CSV_file Options[\"--localcores=16 --localmem=192 --sex=female --targets=SSV3.bed --indices=SI-GA-A1 --uiport=3600\"] [REF_DIR:$REF]"

fi



