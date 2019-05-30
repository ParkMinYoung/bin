#!/bin/sh

. ~/.bash_function

if [ -f "$1" ];then

	perl -F'\s+' -anle'BEGIN{$f=$ARGV[0]; $f=~s/\.fam//;}`echo -e "$F[0]\t$F[0]" > $F[0].sample`; print "plink --bfile $f --keep $F[0].sample --make-bed --out $F[0].$f --noweb"' $1 
	# NGS.geno.cleanup.fam

else
	usage "XXX.fam"
fi

