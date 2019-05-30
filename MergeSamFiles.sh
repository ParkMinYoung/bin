#!/bin/sh
# $1 must be XXX.sam.gz

source ~/.GATKrc

if [ $# -ne 1 ];then
	echo "usage : `basename $0` XXXX.bam"
	java $JMEM -jar $PICARDPATH/MergeSamFiles.jar --help
	exit 0
fi

SortDIR=$(dirname $1)

java $JMEMMAX -jar $PICARDPATH/MergeSamFiles.jar 	\
INPUT=$1					\
OUTPUT=$1.sorted.bam 				\
SORT_ORDER=$SORT_ORDER 				\
VALIDATION_STRINGENCY=$VALIDATION_STRINGENCY	\
MAX_RECORDS_IN_RAM=$MAX_RECORDS_IN_RAM 		\
CREATE_MD5_FILE=$CREATE_MD5_FILE		\
CREATE_INDEX=$CREATE_INDEX			\
TMP_DIR=$SortDIR                                \
>& $1.sorted.bam.log


# USE_THREADING=$USE_THREADING			\
# TMP_DIR=$TMP_DIR                                \
