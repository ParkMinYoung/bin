#!/bin/sh

. ~/.bash_function

if [ $# -ge 2 ] & [ -f "$1" ]; then

	IN=$1
	ID=$2
	D=$3
	G=$4
	
	DP=${D:=10}
	GQ=${G:=90}

	#vcftools --vcf $IN --indv $ID --remove-filtered-all --minGQ $GQ --minDP $DP --maxDP 10000 --out $ID --recode5
	# -remove-indels or --keep-only-indels 
    # -remove-filtered-all

	vcftools --vcf $IN --indv $ID --minGQ $GQ --minDP $DP --maxDP 10000 --out $ID --recode --recode-INFO-all --remove-indels --stdout | grep -v -e "0\/0" -e "\.\/\." > $ID.vcf

else
	usage "XXX.vcf ID DP[10] GQ[90]"
fi


