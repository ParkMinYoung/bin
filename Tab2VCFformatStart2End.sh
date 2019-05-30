#!/bin/sh

. ~/.bash_function

if [ -f "$1" ];then

	perl -F'\t' -anle'$r=length($F[3]); $F[0]="chr$F[0]" if $F[0] !~ /^chr/; $F[1]=$F[1]+($r-1) if $r>1; print join "\t", @F' $1 > $1.Start2End.tab
	Tab2VCF.sh $1.Start2End.tab

else
	usage "XXX.tab"
fi


