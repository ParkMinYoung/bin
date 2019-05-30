#!/bin/bash

. ~/.bash_function

if [ $# -ge 1 ]; then

	for i in $@
	do	
		FastqRename.InsertIndex_.sh $i
	done

else
	
cat <<EOF

$(_red "Renaming Script that auto detected index strings will be inserted")

EOF

	usage "NoIndex.fastq.gz ..."

fi

