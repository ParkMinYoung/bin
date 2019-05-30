#!/bin/sh


source ~/.GATKrc

if [ $# -eq 0 ];then
	echo "usage : `basename $0` XXXX.bam [YYYY.intervals]"
	java $JMEM -jar $EGATK -T GCContentByInterval --help
	exit 1
fi

L=$2
INTERVAL=${L:=$SureSelectINTERVAL}

TMPDIR=$(dirname $1)

# MAX_INSERT_SIZE=1000[default:100000]
java $JMEM -Djava.io.tmpdir=$TMPDIR -jar $EGATK  	\
-T GCContentByInterval					\
-R $REF									\
-o GCContentByInterval.report			\
-L $INTERVAL							\
>& GCContentByInterval.log

