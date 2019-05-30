#!/bin/bash

. ~/.bash_function
. ~/.minyoungrc

if [ -f "$1" ] ; then

#		T_BAM=/home/adminrig/analysis/bam/DPBL_041.22.synthetic_output/DPBL_041.22.syn.bam
#		N_BAM=/home/adminrig/analysis/bam/DPBL_041.22.synthetic_output/DPNT_041.22.syn.bam
		BAM=$(readlink -f $1)

		OUTPUT_DIR=${2:-somaticseq_result}
		OUTPUT_DIR=$(readlink -f $OUTPUT_DIR)
		ACTION=${3:-echo}
		Nthreads=${4:-1}

		inclusion_region=${5:-$BED}


		[[ ! -d $OUTPUT_DIR ]] && mkdir $OUTPUT_DIR

		$somaticseq/utilities/dockered_pipelines/makeSomaticScripts.py \
		single 											\
		--bam              			$BAM 				\
		--genome-reference 			$REF 				\
		--output-directory 			$OUTPUT_DIR 		\
		--dbsnp-vcf        			$DBSNP_VCF 			\
		--cosmic-vcf 				$COSMIC_VCF 		\
		--action           			"$ACTION" 			\
		--threads          			$Nthreads 			\
		--inclusion-region 			$inclusion_region 	\
		--exome											\
		--run-mutect2 --run-vardict --run-lofreq --run-scalpel --run-strelka2 --run-somaticseq


		cd $OUTPUT_DIR

		## add "--keep-intermediates -mincaller 0.0 options" to somaticSeq.xxxxx.cmd file 
		sed -i.bak '/single/ i --keep-intermediates -mincaller 0.0 \\' $(find SomaticSeq/logs/ | grep cmd$)


		if [ $ACTION == "qsub" ];then

				_somaticseq_find_script_waiting.sh somaticSeq mergeResult
		fi


else
		echo -e "\n"
		echo "If input bams are the subset bam of a sepecific chromsome or small sizes target, Nthreads must be setted to 1"
		echo "Too many Nthreads do not creat output vcf file of the specific caller, so you encounter the errors."
		echo "The problem that currently is identified is the [MuSE.vcf]"

		usage "/asolute/path/Tumor.bam [/absolute/path/out_dir] [echo|qsub] [Nthreads] [inclusion-bed]"

fi
