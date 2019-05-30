#!/bin/sh

. ~/.bash_function

PICARD=/home/adminrig/src/picard/picard-tools-1.128/picard.jar

if [ -f "$1" ] & [ -d "$2" ];then 

	cd $2

	perl -F"\t" -anle'if(/(Z|H|X)$/ && ! $h{$F[0]}++){print $F[0]}' *_context_*.deduplicated.txt > TargetRead

	java -Xmx4g -jar $PICARD SortSam I=$1 O=$2.bam SORT_ORDER=coordinate CREATE_INDEX=true TMP_DIR=$PWD

	java -Xmx32g -jar $PICARD FilterSamReads I=$2.bam O=$2.bam.Meth.bam READ_LIST_FILE=TargetRead FILTER=includeReadList SORT_ORDER=coordinate CREATE_INDEX=true TMP_DIR=$PWD

else

	usage "XXX.bam DIR"


fi







