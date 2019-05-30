#!/bin/sh

. ~/.bash_function

if [ -f "$1" ] & [ -f "$2" ];then

	join.h.NA.sh $1 $2 $3 $4 $5 > $1.annot
	#join.h.sh $1 $2 $3 $4 $5 > $1.annot


	head -1 $1 | tr "\t" "\n" > header 
	head -1 $2 | cut -f $5 | tr "\t" "\n" >> header

	(perl -nle'push @l, $_; }{ print join "\t", @l' header; sed -n '2,$'p $1.annot) > $1.annotation
	rm -rf $1.annot header

else
     usage "XXX YYY \"1,2,3,4,5\" \"1,2,3,4,5\" \"3,5,6,7,9,10\" ## output format : X + Y "
fi

