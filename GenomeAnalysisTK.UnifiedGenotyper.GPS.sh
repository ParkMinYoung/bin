#!/bin/sh

# GenomeAnalysisTK.sh 
# $6 must be [XXX.bam]
# output      
#             
#             

source ~/.bash_function
GATK_param


if [ $# -eq 0 ];then

	D=/home/adminrig/Genome/GPS.lib/RS.region.intervals
	D_G=/home/adminrig/Genome/GPS.lib/Disease.intervals
	G=/home/adminrig/Genome/GPS.lib/RS.region.genectic.intervals

	echo "Disease : $D" 
	echo "Disease.Gene: $D_G" 
	echo "Genetics: $G" 
	echo "GenomeAnalysisTK.UnifiedGenotyper.GPS.sh $D \`ls *.bam | sort\` &"
	echo "GenomeAnalysisTK.UnifiedGenotyper.GPS.sh $D_G \`ls *.bam | sort\` &"
	echo "GenomeAnalysisTK.UnifiedGenotyper.GPS.sh $G \`ls *.bam | sort\` &"
	echo "usage : `basename $0` intervals XXXX.bam yyyy.bam zzz.bam ..."
	java $JMEM -jar $EGATK -T UnifiedGenotyper --help	
	exit 1
fi

EGATK=/home/adminrig/src/GATK/GenomeAnalysisTK-1.2-60-g585a45b/$GATK

INTERVAL=$1
OUT=$(basename $INTERVAL)
shift

for i in $@;
    do 
	if [ -e $i ];then
	    IN=$(echo "$IN -I $i")
	else
	    usage "bam file dont exist!"
	fi
done

TMPDIR=$(dirname $1)

# MAX_INSERT_SIZE=1000[default:100000]
java $JMEMMax -Djava.io.tmpdir=$TMPDIR -jar $EGATK  	\
-T UnifiedGenotyper		\
-l INFO \
-R $REF \
$IN 	\
--dbsnp $VCF										\
--standard_min_confidence_threshold_for_calling	50	\
--standard_min_confidence_threshold_for_emitting 10 \
-o $OUT.GPS.snp.raw.vcf 			\
-L $INTERVAL					\
--metrics_file $1.metrics 		\
-A DepthOfCoverage 			\
-A AlleleBalance			\
-A BaseQualityRankSumTest		\
-A HomopolymerRun			\
-A MappingQualityRankSumTest		\
-A MappingQualityZero			\
-A QualByDepth				\
-A RMSMappingQuality			\
-A SpanningDeletions			\
-A HaplotypeScore			\
--min_base_quality_score 30		\
--min_mapping_quality_score 20		\
-dcov 10000 				\
-glm BOTH				\
-nt 4 					\
--p_nonref_model EXACT			\
--output_mode EMIT_ALL_SITES		\
>& $OUT.GPS.log


# for all site
### --output_mode EMIT_ALL_SITES		\






## must be reseted
# -L $SureSelectINTERVAL			\



# --default_platform illumina     	\  do not use
# --default_read_group $RG        	\  do not use
# --output_mode EMIT_ALL_SITES		\  if u want to all sites, use this
# --min_base_quality_score 30           \  if u want to many results, use lower values [20]


# --standard_min_confidence_threshold_for_calling	default 30
# deep date (10x or better) is recommended as 50

# --output_all_callable_bases \
# --verbose_mode $1.verbose \
# --genotype			\



# -B:comp1KG,VCF $PT1KG					\
# -B:compHapmap,VCF $HAPMAP				\
