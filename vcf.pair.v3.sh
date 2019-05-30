#!/bin/bash

. ~/.bash_function


if [ -f "$1" ] & [ -f "$2" ] & [ $# -eq 5 ];then

VCFTOOLS=/home/adminrig/src/vcf-tools/vcftools_0.1.9/bin/vcftools
Version=vcftools_0.1.9
Version=$3.$4.$5
ID=$3

mkdir $Version


V1=$(readlink -f $1)
V2=$(readlink -f $2)

V1_=$(basename $1)
V2_=$(basename $2)

File2Dir.sh $Version $V1
File2Dir.sh $Version $V2

cd $Version


vcftools.extract.sample.sh $V1 "$ID" 0 0
vcftools --vcf $ID.recode.vcf --minGQ $4 --minDP $5 --maxDP 10000 --out $V1_ --recode

vcftools.extract.sample.sh $V2 "$ID" 0 0
vcftools --vcf $ID.recode.vcf --minGQ $4 --minDP $5 --maxDP 10000 --out $V2_ --recode



$VCFTOOLS --vcf $V1_.recode.vcf --diff $V2_.recode.vcf --diff-discordance-matrix --diff-site-discordance --diff-indv-discordance --minGQ $4 --minDP $5 --remove-filtered LowQual --maxDP 10000 --out $3
#$VCFTOOLS --vcf  $1 --diff $2 --diff-site-discordance --minGQ 90 --minDP 10 --remove-filtered LowQual --maxDP 10000 --out SNV.DP10.GQ90
#$VCFTOOLS --vcf  $1 --diff $2 --diff-discordance-matrix --minGQ 90 --minDP 10 --remove-filtered LowQual --maxDP 10000 --out SNV.DP10.GQ90
#$VCFTOOLS --vcf  $1 --diff $2 --diff-indv-discordance --minGQ 90 --minDP 10 --remove-filtered LowQual --maxDP 10000 --out SNV.DP10.GQ90

else
	usage "A.vcf B.vcf Output_Name GQ DP"
fi

