#!/bin/bash

. ~/.bash_function


if [ -f "$1" ] & [ $# -ge 1 ]; then
	
	TARGET=$1
	shift 

	OUT=$1
	shift

	(echo $@ | tr " " "\t"; cat $TARGET) > $OUT


else
	echo "./AddHeader.sh  add.B Final.Concordance.summary.txt \$\(head -1 Final.Concordance | cut -f1-6\) A.DQC A.CR A.HET B.DQC B.CR B.HET"
	usage "TARGET OUTPUT_NAME [header ids...]"
fi

