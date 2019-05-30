#!/bin/sh

. ~/.bash_function

if [ -f "$1" ];then

	SIFT=/home/adminrig/src/SNPEFF/snpEff_4_2/SnpSift.jar
	HV=/home/adminrig/Genome/MT/HyperVariableRegion_I_II.bed

	(grep ^# $1; bedtools intersect -a $1 -b $HV) > $1.HV.vcf
	java -jar $SIFT varType  $1.HV.vcf > $1.HV.vcf.Type.vcf
	java -Xmx32g -jar $SIFT extractFields  $1.HV.vcf.Type.vcf "CHROM" "POS" "ID" "REF" "ALT" AF TYPE HOM HET DP RO AO GT SAF SAR SRF SRR > $1.HV.vcf.Type.vcf.tab

	# excute time : 2016-08-19 18:12:14 : final step
	perl -F'\t' -anle'next if $.==1; push @list, $F[1].$F[4]; }{ print join " ", @list' $1.HV.vcf.Type.vcf.tab > $1.HV.vcf.Type.vcf.tab.list 

else
	usage "XXX.vcf"
fi



