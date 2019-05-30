#!/bin/sh

# GenomeAnalysisTK.sh 
# $1 must be [XXX.bam]
# output      
#             
#             

source ~/.GATKrc

if [ $# -eq 0 ];then
	echo "usage : `basename $0` XXXX.bam"
	java $JMEM -jar $EGATK -T CountLoci --help
	exit 1
fi

L=$2
INTERVAL=${L:=$SureSelectINTERVAL}

TMPDIR=$(dirname $1)

# MAX_INSERT_SIZE=1000[default:100000]
java $JMEM -Djava.io.tmpdir=$TMPDIR -jar $EGATK  	\
-T CountLoci							\
-R $REF									\
-o $1.CountLoci.report					\
-I $1									\
-nt 4									\
>& $1.CountLoci.log

