#!/bin/sh
# $1 must be XXX.sam.gz

source ~/.GATKrc

if [ $# -ne 1 ];then
	echo "usage : `basename $0` xxx.bam"
	java $JMEM -jar $PICARDPATH/MeanQualityByCycle.jar --help
	exit 0
fi

#readgroup=$3
#RG=${readgroup:="RG.default"}


SortDIR=$(dirname $1)

java $JMEMMAX -jar $PICARDPATH/MeanQualityByCycle.jar 	\
CHART_OUTPUT=$1.MeanQualityByCycle.pdf		\
ALIGNED_READS_ONLY=false					\
PF_READS_ONLY=false							\
INPUT=$1									\
OUTPUT=$1.MeanQualityByCycle.metrics			\
ASSUME_SORTED=true							\
>& $1.MeanQualityByCycle.log


# TMP_DIR=$TMP_DIR                                \
