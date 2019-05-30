#!/bin/sh

. ~/.GATKrc
. ~/.bash_function

LEN=100

if [ -f "$1" ];then

	slopBed -i $1 -b $LEN -g $REF_GENOME > $1.$LEN.bed

else
	usage "XXX.bed"
fi

