#!/bin/sh

# GenomeAnalysisTK.sh 
# $1 must be [XXX.vcf]

# output      
#             
#             

source ~/.GATKrc

if [ $# -eq 0 ];then
	echo "usage : `basename $0` XXXX.vcf "
	java $JMEMMax -jar $EGATK -T VariantRecalibrator --help
	exit 1
fi

TMPDIR=$(dirname $1)

# MAX_INSERT_SIZE=1000[default:100000]
java $JMEMMax -Djava.io.tmpdir=$TMPDIR -jar $EGATK  							\
-T VariantRecalibrator 		\
-l INFO 					\
-R $REF 					\
-B:input,VCF $1	 			\
-B:hapmap,VCF,known=false,training=true,truth=true,prior=15.0 $HAPMAP_Train 	\
-B:omni,VCF,known=false,training=true,truth=false,prior=12.0 $OMNI2_5_1000G 	\
-B:dbsnp,VCF,known=true,training=false,truth=false,prior=8.0 $VCF 				\
--ignore_filter HARD_TO_VALIDATE 												\
--ignore_filter LowQual 	\
-recalFile $1.recal			\
-an QD 						\
-an HaplotypeScore 			\
-an MQRankSum 				\
-an ReadPosRankSum 			\
-an HRun					\
-an FS  					\
-an MQ						\
-an DP						\
-an InbreedingCoeff 		\
--target_titv 3.2 			\
-tranche 100.0 -tranche 99.9 -tranche 99 -tranche 90 							\
-tranchesFile $1.Recalibrated.tranches 	\
-Rscript $R 							\
-resources $GATK_R 						\
-rscriptFile $1.GaussianMixtureModelFit \
-nt 4									\
-mode SNP								\
>& $1.VariantRecalibrator.log
 
# --target_titv 3.0 			\
# -tranche 0.1 -tranche 1 -tranche 10 	\

# if a few bad variants, use
# --maxGaussians 4
# or
# --percentBadVariants 0.05
