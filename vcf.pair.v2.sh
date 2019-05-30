#!/bin/bash

. ~/.bash_function


if [ -f "$1" ] & [ -f "$2" ] & [ $# -eq 5 ];then

VCFTOOLS=/home/adminrig/src/vcf-tools/vcftools_0.1.9/bin/vcftools
Version=vcftools_0.1.9
Version=$3.$4.$5
mkdir $Version

$VCFTOOLS --vcf $1 --diff $2 --diff-discordance-matrix --diff-site-discordance --diff-indv-discordance --minGQ $4 --minDP $5 --remove-filtered LowQual --maxDP 10000 --out $Version/$3
#$VCFTOOLS --vcf  $1 --diff $2 --diff-site-discordance --minGQ 90 --minDP 10 --remove-filtered LowQual --maxDP 10000 --out SNV.DP10.GQ90
#$VCFTOOLS --vcf  $1 --diff $2 --diff-discordance-matrix --minGQ 90 --minDP 10 --remove-filtered LowQual --maxDP 10000 --out SNV.DP10.GQ90
#$VCFTOOLS --vcf  $1 --diff $2 --diff-indv-discordance --minGQ 90 --minDP 10 --remove-filtered LowQual --maxDP 10000 --out SNV.DP10.GQ90

else
	usage "A.vcf B.vcf Output_Name GQ DP"
fi

