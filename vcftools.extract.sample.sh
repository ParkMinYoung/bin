#!/bin/sh

. ~/.bash_function

if [ $# -ge 2 ] & [ -f "$1" ]; then

	IN=$1
	IDs=$2
	D=$3
	G=$4
	
	DP=${D:=10}
	GQ=${G:=90}

	#vcftools --vcf $IN --indv $ID --remove-filtered-all --minGQ $GQ --minDP $DP --maxDP 10000 --out $ID --recode5
	# -remove-indels or --keep-only-indels 
    # -remove-filtered-all

	OPTIONS=$(echo $IDs | sed -e 's/^/--indv /' -e 's/,/ --indv /g')
	ID=$(echo $IDs | sed 's/ //g' | tr "," "\n" | head -1)

	vcftools --vcf $IN $OPTIONS --minGQ $GQ --minDP $DP --maxDP 10000 --out $ID --recode --recode-INFO-all

else
	usage "XXX.vcf IDs(\"A,B,C\")  DP[10] GQ[90]"
fi


