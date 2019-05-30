#!/bin/bash

if [ $# -eq 2 ];then

	perl -F'\t' -MMin -asnle'push @{$h{$F[$col-1]}},$_ }{ map { Array2File($_, @{$h{$_}}) } sort keys %h' -- -col=$2 $1
	# ls AX*txt | xargs -i -n 1 -P10 wrapper.sh perl /home/adminrig/src/short_read_assembly/bin/create_cluster_new.pl {}
else
	usage "File ColumnNum"
fi



