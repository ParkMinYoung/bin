#!/bin/bash

. ~/.bash_function


if [ -f "$1" ];then
	
	DIR=$(dirname $(readlink -f $1))
	OUTPUT=$DIR/$(basename $DIR).bedgraph

	## make bedgraph file
	CX_report.txt2BedGraph.sh $1 > $OUTPUT

	[ ! -f "human.genome" ] && fai2genome.sh

	## make bedgraph.bw file
	bedGraphToBigWig $OUTPUT human.genome $OUTPUT.bw

else
	usage "DMSO1_re1_AACGTGAT_L006_R1_001_bismark_bt2_pe.deduplicated.CX_report.txt"
fi


