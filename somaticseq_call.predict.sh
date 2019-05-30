#!/bin/bash

. ~/.bash_function
. ~/.minyoungrc


if [ -f "$1" ] && [ -f "$2" ]; then

#		T_BAM=/home/adminrig/analysis/bam/DPBL_041.22.synthetic_output/DPBL_041.22.syn.bam
#		N_BAM=/home/adminrig/analysis/bam/DPBL_041.22.synthetic_output/DPNT_041.22.syn.bam
		T_BAM=$(readlink -f $1)
		N_BAM=$(readlink -f $2)

		OUTPUT_DIR=${3:-somaticseq_result}
		OUTPUT_DIR=$(readlink -f $OUTPUT_DIR)
		ACTION=${4:-echo}
		Nthreads=${5:-1}

		snv_classifier=${6:-Ensemble.sSNV.tsv.ntChange.Classifier.RData}
		snv_classifier=$(readlink -f $snv_classifier)
		indel_classifier=${7:-Ensemble.sIndel.tsv.ntChange.Classifier.RData}
		indel_classifier=$(readlink -f $indel_classifier)

		inclusion_region=${8:-$BED}

		[[ ! -d $OUTPUT_DIR ]] && mkdir $OUTPUT_DIR

		$somaticseq/utilities/dockered_pipelines/makeSomaticScripts.py \
		paired \
		--normal-bam 			$N_BAM \
		--tumor-bam 			$T_BAM \
		--genome-reference 		$REF \
		--dbsnp-vcf 			$DBSNP_VCF \
		--cosmic-vcf 			$COSMIC_VCF \
		--output-directory 		$OUTPUT_DIR \
		--action           		"$ACTION" \
		--threads          		$Nthreads \
		--snv-classifier 		$snv_classifier \
		--indel-classifier 		$indel_classifier \
		--inclusion-region		$inclusion_region \
		--run-mutect2 --run-somaticsniper --run-vardict --run-muse --run-lofreq --run-scalpel --run-strelka2 --run-somaticseq
#		--somaticseq-action "qsub" \

 		cd $OUTPUT_DIR

 		if [ $ACTION == "qsub" ];then
 
				_somaticseq_find_script_waiting.sh somaticSeq mergeResult 
 		fi


else
		echo -e "\n"
		echo "If input bams are the subset bam of a sepecific chromsome or small sizes target, Nthreads must be setted to 1"
		echo "Too many Nthreads do not creat output vcf file of the specific caller, so you encounter the errors."
		echo "The problem that currently is identified is the [MuSE.vcf]"

		usage "/asolute/path/Tumor.bam /absolute/path/Normal.bam [/absolute/path/out_dir] [echo|qsub] [Nthreads] [classfier-snv] [classfier-indel] [inclusion-region]"

fi
