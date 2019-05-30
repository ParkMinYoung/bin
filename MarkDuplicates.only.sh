#!/bin/sh

# MarkDuplicates.sh 
# $1 must be [XXX.bam]
# output      XXX.bam.MarkDuplicates
#             XXX.bam.MarkDuplicatesMetrics
#             XXX.bam.MarkDuplicatesMetrics.log

source ~/.GATKrc


if [ $# -eq 0 ];then
	java $JMEM -jar $PICARDPATH/MarkDuplicates.jar --help
else

SortDIR=$(dirname $1)


java $JMEM12 -jar $PICARDPATH/MarkDuplicates.jar 			\
INPUT=$1												\
OUTPUT=$1.Dedupping.bam									\
METRICS_FILE=$1.MarkDuplicatesMetrics					\
ASSUME_SORTED=true										\
REMOVE_DUPLICATES=true									\
VALIDATION_STRINGENCY=LENIENT							\
MAX_RECORDS_IN_RAM=$MAX_RECORDS_IN_RAM					\
CREATE_MD5_FILE=true									\
CREATE_INDEX=true										\
TMP_DIR=$SortDIR 			                    		\
>& $1.MarkDuplicates.log 

# TMP_DIR=$TMP_DIR                                \

fi

