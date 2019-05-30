#!/bin/sh

# CollectInsertSizeMetrics
# $1 must be [XXX.bam]
# output      XXX.CollectInsertSizeMetrics     
#             XXX.CollectInsertSizeMetrics.pdf

source ~/.GATKrc

# MAX_INSERT_SIZE=1000[default:100000]
java $JMEM -jar $PICARDPATH/CollectInsertSizeMetrics.jar \
INPUT=$1								\
OUTPUT=$1.CollectInsertSizeMetrics					\
HISTOGRAM_FILE=$1.CollectInsertSizeMetrics.pdf			\
VALIDATION_STRINGENCY=LENIENT						\
MAX_RECORDS_IN_RAM=$MAX_RECORDS_IN_RAM						\
CREATE_MD5_FILE=true							\
TMP_DIR=$TMP_DIR                                \
>& $1.CollectInsertSizeMetrics.log 

