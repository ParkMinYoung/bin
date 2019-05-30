#!/bin/sh

# GenomeAnalysisTK.sh 
# $1 must be [XXX.bam]
# output      
#             
#             

source ~/.GATKrc
source ~/.bash_function
GATK_param

if [ $# -eq 0 ] || [ $# -ne 2 ];then

	echo "usage : `basename $0` XXXX.bam YYYY.intervals"
	java $JMEM -jar $EGATK -T IndelRealigner --help
	exit 1
fi


# MAX_INSERT_SIZE=1000[default:100000]
java $JMEMMax -Djava.io.tmpdir=$TMP_DIR -jar $EGATK  \
-T IndelRealigner 		\
-R $REF				\
-o $1.IndelRealigner.bam	\
-I $1				\
-targetIntervals $2		\
-compress 5                 	\
--LODThresholdForCleaning 5.0	\
--consensusDeterminationModel USE_READS \
--maxReadsInMemory 300000 	\
--maxConsensuses 30		\
--maxReadsForConsensuses 120	\
--targetIntervalsAreNotSorted	\
>& $1.IndelRealigner.log

# this option can not use, because there is not VCF file
# use option if VCF

# -B:snps,VCF $VCF		\
# -B:indel,VCF $INDELVCF		\


#[-L intervals] \
#[-B:snps,VCF /path/to/SNP_calls.vcf] \
#[-B:indels,VCF /path/to/indel_calls.vcf] \
#[-D /path/to/dbsnp.rod]

#-compress 0						\		# if running FixMateInformation.jar, it's faster to turn off compression
#-LOD 5.0							\		# if low coverage, use lower value than 5.0. if high cov, user higher value th/an 5.0
#--targetIntervalsAreNotSorted		\		# for unsorted intervals file
#--useOnlyKnownIndels				\ 
