#!/bin/sh

# GenomeAnalysisTK.sh 
# $1 must be [XXX.bam]
# output      
#             
#             

source ~/.GATKrc

if [ $# -eq 0 ];then
	echo "usage : `basename $0` XXXX.bam"
	java $JMEM -jar $EGATK -T CountReads --help
	exit 1
fi

L=$2
INTERVAL=${L:=$SureSelectINTERVAL}

TMPDIR=$(dirname $1)

# MAX_INSERT_SIZE=1000[default:100000]
java $JMEM -Djava.io.tmpdir=$TMPDIR -jar $EGATK  	\
-T CountReads							\
-R $REF									\
-I $1									\
-L $INTERVAL 							\
>& $1.CountReads.log

# can not use -o and -nt option 
# -o $1.CountReads.report					\
# -nt 4									\
