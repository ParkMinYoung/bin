#!/bin/sh

. ~/.bash_function

JPT_CHB=/home/adminrig/Genome/1000Genomes/20110521/gunzip.vcf/JPTandCHB.ind

if [ -f "$1" ] && [ -f "$2" ];then

#VCF=ALL.chr17.phase1_release_v3.20101123.snps_indels_svs.genotypes.vcf
VCF=$1
RSLIST=$2

head -1000 $VCF | grep ^# > $RSLIST.vcf
perl -nle'
if(@ARGV){
	$h{$_}++;
}else{
	if(/^#/){
		next
	}else{ 
		($chr,$bp,$rs,$remain)=split "\t", $_, 4; 
		print if $h{$rs};
	}
}' $RSLIST $VCF >> $RSLIST.vcf
#/home/adminrig/Genome/dbSNP/dbSNP138/20140512/rs ALL.chr17.phase1_release_v3.20101123.snps_indels_svs.genotypes.vcf >> VCF

vcftools --vcf $RSLIST.vcf --keep $JPT_CHB --plink --out $RSLIST.vcf.plink # ok
cut -f2,4 $RSLIST.vcf.plink.map  > $RSLIST.vcf.plink.info

java -Xmx196g -Djava.io.tmpdir=./ -jar `which Haploview.jar` -n -log $RSLIST.vcf.plink.hap.log -out $RSLIST.vcf.plink.hap -pedfile $RSLIST.vcf.plink.ped -info $RSLIST.vcf.plink.info -dprime -png -blockoutput GAB -minMAF 0.001 -minGeno 0.75 -hwcutoff 0.0010  -missingCutoff .5 -pairwiseTagging -tagrsqcutoff .8

zip  $(date +%Y%m%d).zip $RSLIST.vcf.plink.ped $RSLIST.vcf.plink.info

else
	usage "xxx.vcf rslist"
fi

