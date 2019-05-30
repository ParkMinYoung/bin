#!/bin/bash

. ~/.bash_function


if [ -f "$1" ] && [ -f "$2" ];then

	BamSimulator=/home/adminrig/src/somaticseq/utilities/dockered_pipelines/bamSimulator/BamSimulator_singleThread.sh

	REF=/home/adminrig/resource/reference/human_g1k_v37.fasta
	BED=/home/adminrig/resource/B3x_SureSelect_V3.bed
	#BED=/home/adminrig/resource/B3x_SureSelect_V3.22.bed
	#T_BAM=/home/adminrig/analysis/bam/DPBL_041.22.bam
	#N_BAM=/home/adminrig/analysis/bam/DPNT_041.22.bam
	T_BAM=$1
	N_BAM=$2
	t_bam=${T_BAM%.bam}.syn.bam
	n_bam=${N_BAM%.bam}.syn.bam
	OUTDIR=${T_BAM%.bam}.synthetic_output


	$BamSimulator \
	--genome-reference  $REF \
	--tumor-bam-in      $T_BAM \
	--normal-bam-in     $N_BAM \
	--tumor-bam-out     $t_bam \
	--normal-bam-out    $n_bam \
	--split-proportion  0.5 \
	--indel-realign    \
	--num-snvs          20000 \
	--num-indels        2000 \
	--min-vaf           0.001 \
	--max-vaf           0.5 \
	--left-beta         2 \
	--right-beta        5 \
	--min-variant-reads 5 \
	--output-dir        $OUTDIR \
	--selector	    $BED \
	--action            qsub 

else
	usage "absolute/path/Tumor.bam absolute/path/Norml.bam"
fi
