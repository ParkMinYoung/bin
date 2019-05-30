#!/bin/sh

# FixMateInformation.sh 
# $1 must be [XXX.bam]
# output
#       
#      

source ~/.GATKrc

# MAX_INSERT_SIZE=1000[default:100000]
java $JMEM -jar $PICARDPATH/FixMateInformation.jar \
INPUT=$1								\
OUTPUT=$1.FixMateInformation.bam							\
VALIDATION_STRINGENCY=SILENT						\
MAX_RECORDS_IN_RAM=$MAX_RECORDS_IN_RAM						\
CREATE_MD5_FILE=true							\
CREATE_INDEX=true								\
SO=coordinate									\
TMP_DIR=$TMP_DIR                                \
>& $1.FixMateInformation.sh.log 

# SO=coordinate or SORT_ORDER=coordinate
