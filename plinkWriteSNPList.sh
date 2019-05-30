#!/bin/sh

. ~/.bash_function

if [ $# -eq 3 ];then

PLINK=$1
IND=$2
DIR=$3


IND_F=$(basename $IND)
OUT=$DIR/$IND_F

if [ ! -d $DIR ];then
	mkdir $DIR
fi


plink --bfile $PLINK --keep $IND --geno 0 --write-snplist --out $OUT --noweb

else
	usage "PLINK_Prefix Indivisual_sample_file output_dir"
fi

