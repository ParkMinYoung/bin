#!/bin/bash

. ~/.bash_function

if [ -f "$1" ] & [ -f "$2" ];then

	export LD_LIBRARY_PATH=/opt/glibc-2.14/lib:/opt/gcc-4.7/lib64:$LD_LIBRARY_PATH
	export LC_ALL="C"
	export LANG="C"
	unset LC_CTYPE

	


	# excute time : 2016-09-29 14:35:10 : excute
	GEN=$1
	SAM=$2
	TSAM=$3 ## will be included sample list

	OUT=${GEN%.gz}.QC.gen
	
	## -omit-chromosome : these are suitable for use with other programs such as GTOOL and IMPUTE
	/home/adminrig/src/qctool/qctool_v1.4-linux-x86_64/qctool -g $GEN -s $SAM -og $OUT -os $OUT.sample -maf 0.000001 1 -info 0.4 1 -incl-samples $TSAM -omit-chromosome -sort &> $OUT.log

else
	
	usage "chr1_10000_2000.gz sample Target_sample"

fi



