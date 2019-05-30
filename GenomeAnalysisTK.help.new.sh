#!/bin/sh

# GenomeAnalysisTK.sh 
# $1 must be [XXX.bam]
# output      
#             
#             

source ~/.GATKrc
EGATK=/home/adminrig/src/GATK/GenomeAnalysisTK-1.2-60-g585a45b/GenomeAnalysisTK.jar

if [ $# -eq 0 ];then
	echo "usage : `basename $0` XXXX.bam"
	java $JMEM -jar $EGATK --help
	exit 1
elif [ $# -eq 1 ];then
	java $JMEM -jar $EGATK -T $1 --help
fi



