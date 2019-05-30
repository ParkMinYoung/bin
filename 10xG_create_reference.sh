#!/bin/bash

. ~/.bash_function
. ~/.minyoungrc

if [ -f "$1" ];then

		FASTA=$1
		NAME=$(basename $FASTA)
		DIR=refdata-${NAME%.*}
	
		[[ ! -d $DIR/fasta ]] && mkdir -p $DIR/fasta

		# execute time : 2019-04-17 14:08:46 : create a lots of files using mkref 
		$LR mkref $FASTA


		# execute time : 2019-04-17 14:08:46 : create .dict file using picard 
		java -jar $PICARD_jar CreateSequenceDictionary R=$FASTA O=$DIR/fasta/genome.dict

else

	usage "reference.fasta"

fi
