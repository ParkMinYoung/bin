#!/bin/sh

# EstimateLibraryComplexity.sh
# $1 must be [XXX.bam]
# output      XXX.bam.EstimateLibraryComplexityMetrics
#	          XXX.EstimateLibraryComplexity.log          

source ~/.GATKrc

# MAX_INSERT_SIZE=1000[default:100000]
java $JMEM -jar $PICARDPATH/EstimateLibraryComplexity.jar \
INPUT=$1								\
OUTPUT=$1.EstimateLibraryComplexityMetrics				\
MIN_MEAN_QUALITY=20							\
VALIDATION_STRINGENCY=LENIENT						\
MAX_RECORDS_IN_RAM=$MAX_RECORDS_IN_RAM						\
CREATE_MD5_FILE=true							\
TMP_DIR=$TMP_DIR                                \
>& $1.EstimateLibraryComplexity.log 

