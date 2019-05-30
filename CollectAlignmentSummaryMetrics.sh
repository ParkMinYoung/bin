#!/bin/sh

# CollectAlignmentSummaryMetrics.sh 
# $1 must be [XXX.bam]
# output      XXX.bam.CollectAlignmentSummaryMetrics
#             XXX.bam.CollectAlignmentSummaryMetrics.log

source ~/.GATKrc

# MAX_INSERT_SIZE=1000[default:100000]
java $JMEM -jar $PICARDPATH/CollectAlignmentSummaryMetrics.jar /\
INPUT=$1								\
OUTPUT=$1.CollectAlignmentSummaryMetrics				\
REFERENCE_SEQUENCE=$REF							\
ASSUME_SORTED=true							\
MAX_INSERT_SIZE=1000							\
VALIDATION_STRINGENCY=LENIENT						\
MAX_RECORDS_IN_RAM=$MAX_RECORDS_IN_RAM						\
CREATE_MD5_FILE=true							\
TMP_DIR=$TMP_DIR								\
>& $1.CollectAlignmentSummaryMetrics.log 


