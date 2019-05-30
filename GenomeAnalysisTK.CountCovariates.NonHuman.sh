#!/bin/sh

# GenomeAnalysisTK.sh 
# $1 must be [XXX.bam]
# output      
#             
#             

source ~/.GATKrc
source ~/.bash_function
GATK_param

if [ $# -eq 0 ];then
	echo "usage : `basename $0` XXXX.bam [ReadGroup] : default VCF:dbDNP132"
	java $JMEM -jar $EGATK -T CountCovariates --help
	exit 1
fi



T=$(date '+%Y%m%d%H%M')
ReadGroup=$2
RG=${ReadGroup:=$T}

# MAX_INSERT_SIZE=1000[default:100000]
java $JMEM -jar $EGATK  		\
-T CountCovariates 			\
-l INFO 					\
-R $REF						\
-I $1						\
-recalFile $1.recal_data.csv	\
-cov ReadGroupCovariate 	\
-cov QualityScoreCovariate 	\
-cov CycleCovariate 		\
-cov DinucCovariate 		\
>& $1.CountCovariates.log


# this option can not use, because there is not VCF file
# use option if VCF
# -B:dbsnp,VCF $VCF			\



# tempory option off 
# --default_read_group $RG        \
# --default_platform illumina     \



## Cov list 

# CycleCovariate: The machine cycle for this base (different definition for the various technologies and therefore platform [@PL tag] is pulled out of the read's read group).
# DinucCovariate: The combination of this base and the previous base.
# QualityScoreCovariate: The reported base quality score for this base.
# ReadGroupCovariate: The read group this read is a member of.

# HomopolymerCovariate: The number of consecutive previous bases that match the current base.
# MappingQualityCovariate: The mapping quality assigned to this read by the aligner.
# MinimumNQSCovariate: The minimum base quality score in a small window in the read around this base.
# PositionCovariate: The position along the length of the read. For Illumina this is the same as machine cycle but that is not the case for the other platforms.
# PrimerRoundCovariate: The primer round for this base (only meaningful for SOLiD reads).
# TileCovariate: The tile from which the read originated, pulled out of the read's name. 


