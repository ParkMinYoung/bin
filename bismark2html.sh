#!/bin/bash

. ~/.bash_function

if [ -d "$1" ]; then

	DIR=$1
	SRC=~/src/bismark/bismark_v0.16.3
	SRC=/home/adminrig/src/bismark/Bismark-master

	# bismark2report
	$SRC/bismark2report -o $DIR.Report.html --alignment_report $DIR/*_bismark_bt2_PE_report.txt --dedup_report $DIR/*_bismark_bt2_pe.deduplication_report.txt --splitting_report $DIR/*001_bismark_bt2_pe.deduplicated_splitting_report.txt --mbias_report $DIR/*_bismark_bt2_pe.deduplicated.M-bias.txt --nucleotide_report none

	# bismark2summary
	$SRC/bismark2summary -o $DIR --title "$DIR Methylseq Result" `find $DIR | grep pe.bam$ | sort`

else
	usage "Bismarkt_Output_Dir"
fi



