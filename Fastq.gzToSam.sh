#!/bin/sh -x

#  $1 : s_? 

source $HOME/.bash_function

if [ $# -ne 1 ]
then
    usage [s_?]
fi

source ~/.GATKrc

java $JMEM -jar $PICARDPATH/FastqToSam.jar \
	 FASTQ=$1/$1.1.fastq.gz    		\
	 FASTQ2=$1/$1.2.fastq.gz  	 	\
	 QUALITY_FORMAT=Illumina 		\
     OUTPUT=$1/$1.unalign.bam 		\
     READ_GROUP_NAME=$1.RG 			\
     SAMPLE_NAME=$1 				\
     LIBRARY_NAME=PE350 			\
     PLATFORM_UNIT=PMIF 			\
     PLATFORM=Illumina 				\
     SORT_ORDER=coordinate			\
	 TMP_DIR=$TMP_DIR               \
	 >& $1/$1.unalign.bam.log


