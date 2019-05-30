#!/bin/bash

. ~/.bash_function

if [ -f "$1" ];then

	perl -F'\t' -anle'if($.>1){ if( $F[2]=~/^rs/ ){ print join "\t", @F[0,2] } }' $1 > AX2RS 

else
	usage "Library_tab[Axiom_PMRA.na35.annot.csv.tab]"
fi


