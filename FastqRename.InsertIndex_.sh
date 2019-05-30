#!/bin/bash

. ~/.bash_function

if [ -f "$1" ]; then


	INDEX=$(zcat $1 | sed -n '1~4'p | head -1000 | grep "\w{6,8}$" -P -o  | sort | uniq -dc | sort -nr -k1,1 | head -1  | grep "\w{6,8}$" -P -o)
	NAME=$(echo $1 | perl -sne's/(.+)_S\d+_(L\d+_R\d_\d+.fastq.gz)/\1_${index}_\2/; print' -- -index=$INDEX)	

	mv $1 $NAME

else

	usage "NoIndex.fastq.gz"

fi

