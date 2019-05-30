#!/bin/sh

. ~/.bash_function

Seed=$3
Frac=$4


if [ -f "$1" ] & [ -f "$2" ];then

	SEED=${Seed:=100}
	FRAC=${Frac:=0.9}

	F1=$1.seed$SEED.frac$FRAC.fastq.gz
	F2=$2.seed$SEED.frac$FRAC.fastq.gz
	
	seqtk sample -s$SEED $1 $FRAC | gzip -c > $F1 &
	seqtk sample -s$SEED $2 $FRAC | gzip -c > $F2 &

	wait

else
	usage "FILE.1.fastq.gz FILE.2.fastq.gz [SEED:100] [FRAC:0.0]"
fi

