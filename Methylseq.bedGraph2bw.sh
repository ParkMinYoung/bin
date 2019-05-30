#!/bin/bash

. ~/.bash_function

if [ -f "$1" ];then
	
	output=${1%.bedGraph.gz}.bw
	tmp=$$

	# execute time : 2018-11-16 14:23:40 : 
#zcat $1 | tail -n +2 | sort -k1,1 -k2,2 > $output.$tmp
	zcat $1 > $output.$tmp.1
	tail -n +2 $output.$tmp.1 | /home/adminrig/workspace.min/Education/bedtools/bedtools2/bin/bedtools sort -i stdin > $output.$tmp


	# execute time : 2018-11-16 14:23:59 : 
	bedGraphToBigWig $output.$tmp $humanG $output

	rm -rf $output.$tmp*


else	
	
	usage "XXX.deduplicated.bedGraph.gz : XXX.deduplicated.bw"

fi

