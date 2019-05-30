#!/bin/bash

. ~/.bash_function

if [ -f "$1.bed" ];then


# excute time : 2017-11-29 10:25:17 : extract DM recode 12
plink2 --bfile $1 --recode12 --out $1 --transpose --tab --allow-no-sex --threads 10  


# excute time : 2017-11-29 10:34:10 : tped 2 genotype
plinkAscTPED2genotype.sh $1.tped  


# excute time : 2017-11-29 10:41:00 : convert num genotype 0,1,2
cut -f3- $1.Genotype | perl -F'\t' -asple' BEGIN{ $h{"11"}=0; $h{"12"}=1; $h{"21"}=1; $h{"22"}=2; $h{"NN"}=$miss||-9 }  if($.>1){ $_ = join "\t", $F[0], map { $h{$_} } @F[1..$#F] } ' -- -miss=$2 > $1.Genotype.num 


else
	usage "Plink"
fi

