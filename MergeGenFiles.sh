#!/bin/bash

. ~/.bash_function

if [ -f "$1" ] & [ -f "$2" ];then

	export LD_LIBRARY_PATH=/opt/glibc-2.14/lib:/opt/gcc-4.7/lib64:$LD_LIBRARY_PATH


	# excute time : 2016-09-29 14:35:10 : excute
	GEN=$1
	SAM=$2
	TSAM=$3 ## will be included sample list

	OUT=${GEN%.gz}.QC.gen

	OUT_gen=$(basename $1)
	OUT_sam=${OUT_gen%.gz}_sample
	
	OUT_DIR=Merge
	[ ! -d "$OUT_DIR" ] && mkdir $OUT_DIR

	
	gen=$OUT_DIR/$OUT_gen
	sam=$OUT_DIR/$OUT_sam

	## -omit-chromosome : these are suitable for use with other programs such as GTOOL and IMPUTE
	/home/adminrig/src/qctool/qctool_v1.4-linux-x86_64/qctool -g $1 -s $2 -g $3 -s $4 -og $gen -os $sam -snp-match-fields position,alleles -match-alleles-to-cohort1 -omit-chromosome  -sort &> $gen.log

else
	
	usage "cohortA.gz cohortB_sample cohortB.gz cohortB_sample"

fi


