#!/bin/sh

# GenomeAnalysisTK.sh 
# $6 must be [XXX.bam]
# output      
#             
#             

source ~/.GATKrc
source ~/.bash_function
GATK_param

#EGATK=/home/adminrig/src/GATK/GenomeAnalysisTK-1.2-60-g585a45b/$GATK

if [ $# -eq 0 ];then
	echo "usage : `basename $0` XXXX.bam yyyy.bam zzz.bam ..."
	java $JMEM -jar $EGATK -T UnifiedGenotyper --help	
	exit 1
fi

# T=$(date '+%Y%m%d%H%M')
# READGROUP=$2
# RG=${READGROUP:=$T}

for i in $@;
    do 
	if [ -e $i ];then
	    IN=$(echo "$IN -I $i")
	else
	    usage "bam file dont exist!"
	fi
done

#TMPDIR=$(dirname $1)
TMPDIR=$PWD

# MAX_INSERT_SIZE=1000[default:100000]
java $JMEMMAX128 -Djava.io.tmpdir=$TMPDIR -jar $EGATK   \
-T UnifiedGenotyper		\
-l INFO 				\
-R $REF 				\
$IN 					\
--standard_min_confidence_threshold_for_calling	50	\
--standard_min_confidence_threshold_for_emitting 30	\
-baq CALCULATE_AS_NECESSARY							\
-o Call.snp.raw.vcf 				\
--metrics_file Call.metrics 		\
-A DepthOfCoverage 				\
-A AlleleBalance				\
-A BaseQualityRankSumTest		\
-A HomopolymerRun				\
-A MappingQualityRankSumTest	\
-A MappingQualityZero			\
-A QualByDepth					\
-A RMSMappingQuality			\
-A SpanningDeletions			\
-A HaplotypeScore				\
-A FisherStrand					\
--min_base_quality_score 20		\
--min_mapping_quality_score 20	\
-dcov 10000 					\
-glm BOTH						\
-nt 4 							\
--p_nonref_model EXACT			\
>& Call.UnifiedGenotyper.log

# http://www.broadinstitute.org/gsa/wiki/index.php/Per-base_alignment_qualities_%28BAQ%29_in_the_GATK

## must be reseted



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




#################################################################################
#################################################################################
#################################################################################
#################################################################################

##### #!/bin/sh
##### 
##### # GATK configure setting var [.GATKrc]
##### 
##### # DB PATH # 
##### REF=/home/adminrig/Genome/Pig/susScr2.fa
##### REF_GENOME=/home/adminrig/Genome/Pig/susScr2.genome
##### 
##### SureSelectNUMBED=/home/adminrig/Genome/Pig/susScr2.target.bed
##### SureSelectCHRBED=/home/adminrig/Genome/Pig/susScr2.target.bed
  

