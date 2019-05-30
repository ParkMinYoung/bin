#!/bin/sh

source ~/.bash_function
source ~/.GATKrc


if [ -f "$1" ];then
	FILE=$1
else
	usage "XXX.pileup"
fi


perl -F'\t' -anle'$s=$F[1]-1;print join "\t",$F[0],$s,$F[1],(join "\|",@F[2..$#F])' $FILE	| \
intersectBed -a stdin -b $SureSelectNUMBED  												| \
perl -F'\t' -anle'print join "\t", $F[0],$F[2], (split /\|/,$F[3])' 						>   $FILE.TargetRegion.Pileup
