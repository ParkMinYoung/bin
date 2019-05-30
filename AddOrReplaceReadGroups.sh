#!/bin/sh
# $1 must be XXX.sam.gz

if [ $# -eq 0 ];then
	echo "usage : `basename $0` XXX.bam s_1(ReadGroup)"
	exit 0
fi

source ~/.GATKrc


T=$(date '+%Y%m%d%H%M')
READGROUP=$2
RG=${READGROUP:=$T}

SortDIR=$(dirname $1)

java $JMEM -jar $PICARDPATH/AddOrReplaceReadGroups.jar 	\
RGID=$RG 				\
RGLB=DNALink.PE 				\
RGPL=illumina 				\
RGSM=$RG				\
RGPU=DNALink.PE.$RG			\
RGCN=DNALink				\
RGDS=NormalProcessingByMinYoung		\
INPUT=$1				\
OUTPUT=$1.AddRG.bam 			\
SORT_ORDER=coordinate 			\
VALIDATION_STRINGENCY=LENIENT 		\
MAX_RECORDS_IN_RAM=1000000 			\
CREATE_MD5_FILE=true 				\
CREATE_INDEX=true				\
TMP_DIR=$SortDIR                                \
>& $1.AddRG.bam.log

# omit 
# TMP_DIR=$TMP_DIR                                \

#USE_THREADING=true 				\


# ls *bam | perl -nle'/(.+)\.bam/; print "AddOrReplaceReadGroups.sh $_ $1 &"; print "wait" if $.%10==0 '  > 01.AddOrReplaceReadGroups.batch
