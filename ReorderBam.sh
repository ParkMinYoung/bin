#!/bin/sh
# $1 must be XXX.sam.gz

if [ $# -eq 0 ];then
	echo "usage : `basename $0` output.name XXX.bam YYY.bam [ZZZ.bam ...]"
	exit 0
fi

source ~/.GATKrc
source ~/.bash_function
GATK_param




java $JMEM -jar $PICARDPATH/ReorderSam.jar 		\
INPUT=$1										\
OUTPUT=$1.Reorder.bam 							\
R=$REF											\
VALIDATION_STRINGENCY=$VALIDATION_STRINGENCY 	\
MAX_RECORDS_IN_RAM=$MAX_RECORDS_IN_RAM 			\
CREATE_MD5_FILE=$CREATE_MD5_FILE 				\
CREATE_INDEX=true								\
TMP_DIR=$TMP_DIR                                \
>& $1.ReorderSam.bam.log

#USE_THREADING=true 				\

