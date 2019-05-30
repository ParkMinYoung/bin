#!/bin/sh
# $1 must be XXX.sam.gz

source ~/.GATKrc

if [ $# -ne 1 ];then
	echo "usage : `basename $0` xxx.bam"
	java $JMEM -jar $PICARDPATH/QualityScoreDistribution.jar --help
	exit 0
fi

#readgroup=$3
#RG=${readgroup:="RG.default"}


SortDIR=$(dirname $1)

java $JMEMMAX -jar $PICARDPATH/QualityScoreDistribution.jar 	\
CHART_OUTPUT=$1.QualityScoreDistribution.pdf		\
ALIGNED_READS_ONLY=true							\
PF_READS_ONLY=true									\
INCLUDE_NO_CALLS=true								\
INPUT=$1											\
OUTPUT=$1.QualityScoreDistribution.metrics			\
ASSUME_SORTED=true									\
>& $1.QualityScoreDistribution.log


# TMP_DIR=$TMP_DIR                                \
