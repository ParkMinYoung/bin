#!/bin/sh
# $1 must be XXX.sam.gz

source ~/.GATKrc

if [ $# -lt 2 ];then
	echo "usage : `basename $0` R1.fastq.gz R2.fastq.gz [ ReadGroup ] [ SampleName ] [ LibraryName ]"
	java $JMEM -jar $PICARDPATH/FastqToSam.jar --help
	exit 0
fi

readgroup=$3
samplename=$4
libaryname=$5

RG=${readgroup:="RG.default"}
SN=${samplename:="SN.default"}
LN=${libraryname:="LN.default"}
PF=Hiseq
SC="DNALink.inc"


SortDIR=$(dirname $1)

java $JMEMMAX -jar $PICARDPATH/FastqToSam.jar 	\
FASTQ=$1									\
FASTQ2=$2									\
QUALITY_FORMAT=Standard						\
OUTPUT=$1.UnAligned.bam						\
READ_GROUP_NAME=$RG							\
SAMPLE_NAME=$SN								\
LIBRARY_NAME=$LN							\
PLATFORM=$PF								\
SEQUENCING_CENTER=$SC						\
SORT_ORDER=unsorted							\
>& $1.UnAligned.bam.log


# TMP_DIR=$TMP_DIR                                \
