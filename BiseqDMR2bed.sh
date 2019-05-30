#!/bin/bash

. ~/.bash_function

if [ -f "$1" ];then

	perl -F'\t' -anle'if($.>1){ --$F[1]; print join "\t", @F[0..2], (join ";", @F[3,4,6,7,8]) }' $1 > ${1/%txt/bed}

else

	usage "DMS.GSK343.biseq.DMRs.annot.txt : DMS.GSK343.biseq.DMRs.annot.bed"

fi

