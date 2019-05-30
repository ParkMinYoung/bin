#!/bin/sh
# $1 must be XXX.sam.gz

source ~/.GATKrc

if [ $# -eq 0 ];then
	echo "usage : `basename $0` OUTPUT.Name XXXX.bam YYY.bam ZZZ.bam ..."
	java $JMEM -jar $PICARDPATH/MergeSamFiles.jar --help
	exit 0
fi

OUTPUT=$1.SortedMerge.bam
shift

for i in $@;
    do
        if [ -e $i ];then
            IN=$(echo "$IN INPUT=$i")
        else
            usage "bam file dont exist!"
        fi
done


SortDIR=$(dirname $OUTPUT)

java $JMEMMAX128 -jar $PICARDPATH/MergeSamFiles.jar 	\
$IN						\
OUTPUT=$OUTPUT	 				\
SORT_ORDER=$SORT_ORDER 				\
VALIDATION_STRINGENCY=$VALIDATION_STRINGENCY	\
MAX_RECORDS_IN_RAM=$MAX_RECORDS_IN_RAM 		\
CREATE_MD5_FILE=$CREATE_MD5_FILE		\
CREATE_INDEX=$CREATE_INDEX			\
TMP_DIR=$SortDIR                                \
USE_THREADING=$USE_THREADING			\
>& $OUTPUT.log


# TMP_DIR=$TMP_DIR                                \
