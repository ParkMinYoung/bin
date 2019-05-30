#!/bin/sh

# GenomeAnalysisTK.sh 
# $1 must be [XXX.vcf]
# output      
#             
#             

source ~/.GATKrc

if [ $# -eq 0 ];then
	echo "usage : `basename $0` XXXX.vcf "
	exit 1
fi


# MAX_INSERT_SIZE=1000[default:100000]
java $JMEM -jar $GATKPATH/GenomeAnalysisTK.jar  \
-T GenerateVariantClusters 				\
-l INFO									\
-R $REF								 	\
-B:input,VCF $1							\
-B:dbsnp,VCF $VCF                       \
-weightDBSNP 0.3 							\
-an QD -an SB -an HaplotypeScore -an HRun \
-clusterFile $1.cluster					\
>& $1.GenerateVariantClusters.log
 
# -weightDBSNP 0
# -weightHapMap 1
# -weight1KG 1


vcf2table.py.sh $1 
VariantRecalibratorReport.R.sh $1 $1.cluster $1.table

