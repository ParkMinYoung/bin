#!/bin/bash


. ~/.bash_function

BOWTIE2_DIR=/home/adminrig/src/BOWTIE/bowtie2-2.1.0
SAMTOOLS_DIR=/home/adminrig/src/SAMTOOLS/samtools-1.3

BISMARK=~/src/bismark/Bismark-0.17.0/bismark
BISMARK_dup=~/src/bismark/Bismark-0.17.0/deduplicate_bismark
BISMARK_call=~/src/bismark/Bismark-0.17.0/bismark_methylation_extractor

Human_REF=/home/adminrig/workspace.min/MethylSeq/Reference


if [ -f "$1" ] && [ -f "$2" ] ;then

	
	R1=$1
	R2=$2
	REF_DIR=${3:-$Human_REF}
	
	OUTPUT_DIR=$(dirname $1)
	

	

	# fastqc
	qsub_wrapper.sh fastqc high.q 1 dependent_job_id n /home/adminrig/src/ngs-analysis/pipelines/ngs.pipe.fastqc.ge.sh 2 $R1 $R2

#	R1=$1.Trim.fastq
#	R2=$2.Trim.fastq
#	/home/adminrig/src/fastx_toolkit/fastxToolkit/bin/fastx_trimmer -f $3 -l $4 -i $1 -Q33 -o $R1 &
#	/home/adminrig/src/fastx_toolkit/fastxToolkit/bin/fastx_trimmer -f $3 -l $4 -i $2 -Q33 -o $R2 &
#	wait

	INPUT=$R1

	BAM=${INPUT%.fastq.gz}"_bismark_bt2_pe.bam"

#	~/src/bismark/bismark_v0.16.3/bismark --pbat --bowtie2 $REF_DIR -1 $R1 -2 $R2 -N 1 -L 20 -p 20 --output_dir $OUTPUT_DIR --path_to_bowtie $BOWTIE2_DIR --non_directional &> $BAM.log
#	~/src/bismark/bismark_v0.16.3/bismark --non_directional --bowtie2 $REF_DIR -1 $R1 -2 $R2 -N 1 -L 20 -p 20 --output_dir $OUTPUT_DIR --path_to_bowtie $BOWTIE2_DIR &> $BAM.log
	$BISMARK --bowtie2 $REF_DIR -1 $R1 -2 $R2 -N 1 -L 20 -p 20 --output_dir $OUTPUT_DIR --path_to_bowtie $BOWTIE2_DIR &> $BAM.log


	$BISMARK_dup --paired --bam --samtools_path $SAMTOOLS_DIR $BAM &> $BAM.dedup.log 

	INPUT=$BAM
	BAM=${INPUT%.bam}.deduplicated.bam
	COV=${BAM%.bam}.bismark.cov.gz

#	~/src/bismark/bismark_v0.16.3/bismark_methylation_extractor --no_overlap --comprehensive --output $OUTPUT_DIR --paired-end --bedGraph --counts --buffer_size 10G --cytosine_report --genome_folder $REF_DIR $BAM &> $BAM.methylextract.log

	$BISMARK_call --no_overlap --comprehensive --output $OUTPUT_DIR --paired-end --merge_non_CpG --CX_context --bedGraph --counts --buffer_size 10G --cytosine_report --genome_folder  $REF_DIR $BAM --multicore 5 &> $BAM.methylextract.log 


#	R CMD BATCH --no-save --no-restore "--args $COV" ~/src/short_read_assembly/bin/R/bismark.cov2png.R

else
	usage "R1.fastq R2.fastq REF_DIR[Human:/home/adminrig/workspace.min/MethylSeq/Reference]"
fi


  
