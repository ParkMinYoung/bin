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

# MAX_INSERT_SIZE=1000[default:100000]
java $JMEM -jar $PICARDPATH/MarkDuplicates.jar 			\
INPUT=$1												\
OUTPUT=$1.Dedupping.Mark.bam									\
METRICS_FILE=$1.Mark.MarkDuplicatesMetrics					\
ASSUME_SORTED=true										\
REMOVE_DUPLICATES=false									\
VALIDATION_STRINGENCY=LENIENT							\
MAX_RECORDS_IN_RAM=$MAX_RECORDS_IN_RAM					\
CREATE_MD5_FILE=true									\
CREATE_INDEX=true										\
TMP_DIR=$SortDIR 			                    		\
>& $1.Mark.MarkDuplicates.log 

# TMP_DIR=$TMP_DIR                                \
F=$1.Dedupping.Mark.bam
samtools flagstat $F > $F.flagstats
 

fi

