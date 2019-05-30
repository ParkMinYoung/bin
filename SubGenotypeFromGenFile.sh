#!/bin/bash

. ~/.bash_function

if [ -f "$1" ];then

	export LD_LIBRARY_PATH=/opt/glibc-2.14/lib:/opt/gcc-4.7/lib64:$LD_LIBRARY_PATH


	# excute time : 2016-09-29 14:35:10 : excute
	GEN=$1

	OUT=${GEN%.gz}.QC.gen

	## -omit-chromosome : these are suitable for use with other programs such as GTOOL and IMPUTE
	/home/adminrig/src/qctool/qctool_v1.4-linux-x86_64/qctool -g $GEN -og $OUT -maf 0.000001 1 -info 0.4 1 -omit-chromosome -sort &> $OUT.log

else
	
	usage "chr1_10000_2000.gz"

fi



