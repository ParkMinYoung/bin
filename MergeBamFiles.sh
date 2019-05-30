#!/bin/sh
# $1 must be XXX.sam.gz

if [ $# -eq 0 ];then
	echo "usage : `basename $0` output.name XXX.bam YYY.bam [ZZZ.bam ...]"
	exit 0
fi

source ~/.GATKrc.max

NAME=$1
shift

for i in $@
	do
	if [ ! -e $i ]
		then
		echo "$i not exit"
		echo "usage : `basename $0` XXX.bam YYY.bam [ZZZ.bam ...]"
		exit 1 
	fi
done

INPUT=$(perl -le'@l=map{$_="INPUT=$_"}@ARGV;END{print join " ",@l}' $@)


java $JMEM -jar $PICARDPATH/MergeSamFiles.jar 	\
$INPUT					 			\
OUTPUT=$NAME.bam 					\
SORT_ORDER=coordinate 				\
VALIDATION_STRINGENCY=$VALIDATION_STRINGENCY 	\
MAX_RECORDS_IN_RAM=$MAX_RECORDS_IN_RAM 			\
CREATE_MD5_FILE=$CREATE_MD5_FILE 				\
TMP_DIR=$TMP_DIR                                \
>& $NAME.bam.log

#USE_THREADING=true 				\

