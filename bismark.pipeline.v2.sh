#!/bin/sh

#  ~/src/bismark/bismark_v0.16.3/bismark --bowtie2 /home/adminrig/workspace.min/MethylSeq/Reference/ -1 ./41_Normal/41_Normal_TTAGGC_L005_R1_001.fastq -2 ./41_Normal/41_Normal_TTAGGC_L005_R2_001.fastq -N 1 -L 20 -p 4 --path_to_bowtie /home/adminrig/src/BOWTIE/bowtie2-2.1.0 >& ./41_Normal/41_Normal_TTAGGC_L005_R1_001.fastq_bismark_bt2_pe.sam.log


. ~/.bash_function

REF_DIR=/home/adminrig/workspace.min/SKKU_YoonHwansoo.GP_Gracilariopsis_chorda/Reference
BOWTIE2_DIR=/home/adminrig/src/BOWTIE/bowtie2-2.1.0
SAMTOOLS_DIR=/home/adminrig/src/SAMTOOLS/samtools-1.3

if [ -f "$1" ] & [ -f "$2" ];then

	
	OUTPUT_DIR=$(dirname $1)
	
	R1=$1.Trim.fastq
	R2=$2.Trim.fastq

	R1=$1
	R2=$2
	
	# fastqc
	qsub_wrapper.sh fastqc high.q 1 dependent_job_id n /home/adminrig/src/ngs-analysis/pipelines/ngs.pipe.fastqc.ge.sh 2 $R1 $R2

#	/home/adminrig/src/fastx_toolkit/fastxToolkit/bin/fastx_trimmer -f $3 -l $4 -i $1 -Q33 -o $R1 &
#	/home/adminrig/src/fastx_toolkit/fastxToolkit/bin/fastx_trimmer -f $3 -l $4 -i $2 -Q33 -o $R2 &
#	wait

	INPUT=$R1

	BAM=${INPUT%.fastq.gz}"_bismark_bt2_pe.bam"

#	~/src/bismark/bismark_v0.16.3/bismark --pbat --bowtie2 $REF_DIR -1 $R1 -2 $R2 -N 1 -L 20 -p 20 --output_dir $OUTPUT_DIR --path_to_bowtie $BOWTIE2_DIR --non_directional &> $BAM.log
	~/src/bismark/bismark_v0.16.3/bismark --non_directional --bowtie2 $REF_DIR -1 $R1 -2 $R2 -N 1 -L 20 -p 20 --output_dir $OUTPUT_DIR --path_to_bowtie $BOWTIE2_DIR &> $BAM.log
#	~/src/bismark/bismark_v0.16.3/bismark --bowtie2 $REF_DIR -1 $R1 -2 $R2 -N 1 -L 20 -p 20 --output_dir $OUTPUT_DIR --path_to_bowtie $BOWTIE2_DIR &> $BAM.log


	~/src/bismark/bismark_v0.16.3/deduplicate_bismark --paired --bam --samtools_path $SAMTOOLS_DIR $BAM &> $BAM.dedup.log 

	INPUT=$BAM
	BAM=${INPUT%.bam}.deduplicated.bam
	COV=${BAM%.bam}.bismark.cov.gz

#	~/src/bismark/bismark_v0.16.3/bismark_methylation_extractor --no_overlap --comprehensive --output $OUTPUT_DIR --paired-end --bedGraph --counts --buffer_size 10G --cytosine_report --genome_folder $REF_DIR $BAM &> $BAM.methylextract.log

	~/src/bismark/bismark_v0.16.3/bismark_methylation_extractor --no_overlap --comprehensive --output ./ --paired-end --merge_non_CpG --CX_context --bedGraph --counts --buffer_size 10G --cytosine_report --genome_folder  $REF_DIR $BAM --multicore 5 &> $BAM.methylextract.log 



	BEDTOOLS=/home/adminrig/workspace.min/Education/bedtools/bedtools2/bin/bedtools
	BED=/home/adminrig/workspace.min/SKKU_YoonHwansoo.GP_Gracilariopsis_chorda/Reference/Target.bed

	$BEDTOOLS coverage -b $BAM -a $BED -hist > $BAM.hist
	$BEDTOOLS coverage -b $BAM -a $BED -d > $BAM.d

	grep ^all $BAM.hist > $BAM.hist.all

	perl -F'\t' -anle'BEGIN{ @idx=(1, map { $_ * 5 } 1..20 ) }  if(/^all/){ $cum+=$F[4]; push @value, $cum}; $bases+=$F[1]*$F[2]; $total=$F[3] }{ print "DP\t$ARGV"; map { print join "\t", $_, (1-$value[$_-1])*100} @idx; print join "\t","MeanDP",$bases/$total; print "OnTargetBases\t$bases\nTargetBases\t$total"; ' $BAM.hist.all > $BAM.hist.all.DP

	
	R CMD BATCH --no-save --no-restore "--args $COV" ~/src/short_read_assembly/bin/R/bismark.cov2png.R

else
	usage "R1.fastq R2.fastq 11 91"
fi


  
