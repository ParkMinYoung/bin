#!/bin/sh

# CollectGcBiasMetrics.sh
# $1 must be [XXX.bam]
# output      XXX.CollectGcBiasMetrics
#             XXX.CollectGcBiasMetrics.summary
#             XXX.CollectGcBiasMetrics.pdf
#	      XXX.CollectGcBiasMetrics.log


source ~/.GATKrc

# MAX_INSERT_SIZE=1000[default:100000]
java $JMEM -jar $PICARDPATH/CollectGcBiasMetrics.jar \
INPUT=$1								\
OUTPUT=$1.CollectGcBiasMetrics						\
REFERENCE_SEQUENCE=$REF							\
CHART_OUTPUT=$1.CollectGcBiasMetrics.pdf				\
SUMMARY_OUTPUT=$1.CollectGcBiasMetrics.summary				\
VALIDATION_STRINGENCY=LENIENT						\
MAX_RECORDS_IN_RAM=$MAX_RECORDS_IN_RAM						\
CREATE_MD5_FILE=true							\
TMP_DIR=$TMP_DIR                                \
>& $1.CollectGcBiasMetrics.log 

