#!/bin/sh
# $1 must be XXX.sam.gz

if [ $# -eq 0 ];then
	echo "usage : `basename $0` input.bam output.bam"
	exit 0
fi

source ~/.GATKrc



java $JMEM -jar $PICARDPATH/BuildBamIndex.jar 	\
INPUT=$1					 			\
VALIDATION_STRINGENCY=$VALIDATION_STRINGENCY 	\
MAX_RECORDS_IN_RAM=$MAX_RECORDS_IN_RAM 			\
CREATE_MD5_FILE=$CREATE_MD5_FILE 				\
TMP_DIR=$TMP_DIR                                \
>& $1.bai.log


