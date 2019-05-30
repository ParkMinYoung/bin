#!/bin/sh

# AnalyzeCovariates.sh 

# $1 must be [XXX.bam]
# output      
#             
#             

source ~/.GATKrc


if [ $# -eq 0 ] || [ ! -e $1 ];then
	echo "usage : `basename $0` XXXX.recal_data.csv output_dir"
	exit 1
fi

if [ -z "$2" ];then
	echo "usage : `basename $0` XXXX.recal_data.csv output_dir"
	echo "         $2 do not exist"
	exit 1
elif [ -n "$2" ];then
	OUT_DIR=$2
	mkdir $OUT_DIR
fi

# MAX_INSERT_SIZE=1000[default:100000]
java $JMEM -jar $EAC  \
-recalFile $1 \
-Rscript $R \
-resources $R_subdir \
-outputDir $OUT_DIR \
-ignoreQ 5 \
>& $1.AnalyzeCovariates.log

pdfmerge.sh `ls $OUT_DIR/*.pdf | sort`

# -resources $REF \
