#!/bin/bash

. ~/.bash_function
#for i in $(ls *.fastq.gz | grep "_S\\d+_L00\\d" -P); do /home/adminrig/src/short_read_assembly/bin/FastqRename.InsertIndex.sh $i; done


if [ $# -ge 1 ] && [ -f "$1" ];then

		for i in $@
			do /home/adminrig/src/short_read_assembly/bin/FastqRename.InsertIndex.sh $i
		done

else	

		usage "A B C ....[Novaseq Name Rule raw fastq files]"

fi

