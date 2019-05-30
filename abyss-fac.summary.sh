#!/bin/sh

source ~/.bash_function

if [ $# -ge 1 ] && [ -f "$1" ]
then

#for i in $@;do abyss-fac $i > $i.fac;done
	for i in $@;do GetAssemStat.sh $i 100 > $i.fac;done
	perl -F'\t' -MMin -ane'chomp@F;$h{$F[0]}{$ARGV}=$F[1] if @F==2 }{ mmfss("fac.summary",%h)' `find | grep fac$`

else
	usage "A.fa B.fa ..."
fi

