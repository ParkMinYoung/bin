#!/bin/sh

source ~/.bash_function

if [ -f "$1" ] ;then

		perl -F'\t' -anle'
#		$exp+=$F[5];
#		$len+=$F[6];
$exp+=$F[4];
$len+=$F[5];
		}{ $p=$exp/$len*100;print "Exp:LEN:Percent=$exp:$len:$p"' $1

else
		usage "XXX.bed"
fi

