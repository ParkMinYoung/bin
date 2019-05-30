#!/bin/sh

# SamToFastq.sh 
# $1 must be [XXX.bam]
# output      XXX.(sanger.)?{1,2}.fastq

source ~/.GATKrc

NAME=$(echo $1 | sed 's/\.bam//;s/unalign/sanger/')

# MAX_INSERT_SIZE=1000[default:100000]
java $JMEM -jar $PICARDPATH/SamToFastq.jar	\
INPUT=$1								\
FASTQ=$NAME.1.fastq							\
SECOND_END_FASTQ=$NAME.2.fastq						\
VALIDATION_STRINGENCY=LENIENT						\
MAX_RECORDS_IN_RAM=$MAX_RECORDS_IN_RAM						\
CREATE_MD5_FILE=true							\
TMP_DIR=$TMP_DIR                                \
>& $1.SamToFastq.log 

#gzip -c $NAME.1.fastq > $NAME.1.fastq.gz
#gzip -c $NAME.2.fastq > $NAME.2.fastq.gz

