#!/bin/bash


. ~/.bash_function



default_REF=/home/adminrig/workspace.min/MethylSeq/Reference/human_g1k_v37.fasta
#default_BED=/home/adminrig/Genome/SureSelect/Methyl-Seq/SureSelect.MethylSeq.84M.bed
bedtools=/home/adminrig/workspace.min/Education/bedtools/bedtools2/bin/bedtools

CX_report=$1
REF=${2:-$default_REF}
#BED=${3:-$default_BED}
GENOME=$(basename $REF).genome

if [ -f "$CX_report" ]; then

	[ ! -f $REF.fai ] && samtools faidx $REF


	cd $(dirname $CX_report)

	# excute time : 2017-11-23 14:10:50 : get genome
	[ ! -f $GENOME ] && cut -f1,2 $REF.fai | grep ^\\d+ -P | sort -n -k1,1 > $GENOME


	# excute time : 2017-11-23 14:11:47 : make windows
	[ ! -f $GENOME.100Kbp.bed ] && $bedtools makewindows -g $GENOME -w 100000 > $GENOME.100Kbp.bed



	# excute time : 2017-11-23 14:37:07 : split CX_report files
	split_ContextByStrandFrom.CX_report.sh $(basename $CX_report)
	#1_control_ACAGTG_L001_R1_001.fastq_bismark_bt2_pe.deduplicated.CX_report.txt 


	# excute time : 2017-11-23 14:52:05 : count in 100Kbp bin
	for i in C*.bed; do $bedtools intersect -a $GENOME.100Kbp.bed -b $i -c > $i.count; sed -i '1 i\chr\tstart\tend\tcount' $i.count  ; done



	# excute time : 2017-11-23 15:12:49 : merge file
	AddRow.w.sh $(basename $PWD).bin '(.+).bed' Context *.bed.count | grep ^Add | sh 

else
	usage "XXX.deduplicated.CX_report.txt [REF:human_g1k_v37.fasta]"
fi


