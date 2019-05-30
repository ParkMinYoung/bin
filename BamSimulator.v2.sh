#!/bin/bash

. ~/.bash_function


if [ -f "$1" ] && [ -f "$2" ];then

	BamSimulator=/home/adminrig/src/somaticseq/utilities/dockered_pipelines/bamSimulator/BamSimulator_singleThread.sh

	REF=/home/adminrig/resource/reference/human_g1k_v37.fasta
	BED=/home/adminrig/resource/B3x_SureSelect_V3.bed

	#BED=/home/adminrig/resource/B3x_SureSelect_V3.22.bed
	#T_BAM=/home/adminrig/analysis/bam/DPBL_041.22.bam
	#N_BAM=/home/adminrig/analysis/bam/DPNT_041.22.bam

	T_BAM=$(readlink -f $1)
	N_BAM=$(readlink -f $2)
	ACTION=${3:-qsub}
	BED=${4:-$BED}

	t_bam=${T_BAM%.bam}.syn.bam
	n_bam=${N_BAM%.bam}.syn.bam
	OUTDIR=${T_BAM%.bam}.synthetic_output

	$BamSimulator \
	--genome-reference  $REF 		\
	--tumor-bam-in      $T_BAM 		\
	--normal-bam-in     $N_BAM 		\
	--tumor-bam-out     $t_bam 		\
	--normal-bam-out    $n_bam 		\
	--split-proportion  0.5 		\
	--indel-realign    				\
	--num-snvs          20000 		\
	--num-indels        2000 		\
	--min-vaf           0.001 		\
	--max-vaf           0.5 		\
	--left-beta         2 			\
	--right-beta        5 			\
	--min-variant-reads 5 			\
	--indel-realign       			\
	--seed              1234 		\
	--output-dir        $OUTDIR 	\
	--selector	    	$BED 		\
	--action            "$ACTION" 

else
	usage "absolute/path/Tumor.bam absolute/path/Norml.bam [qsub|echo] [inclusion_bed]"
fi



# sed -n '/synthetic_indels.vcf"/'p $OUTDIR/logs/BamSimulator.*.cmd
# 

#sed  -n '/somaticseq:base-1.1/,$'p $OUTDIR/logs/BamSimulator.*.cmd  | sed '1 i\ rm -rf synthetic_indels.vcf.idx; ' > $OUTDIR/logs/cmd.v2
#_waiting BamSimul
#sh $OUTDIR/logs/cmd.v2

