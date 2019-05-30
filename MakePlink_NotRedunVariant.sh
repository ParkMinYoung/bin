#!/bin/bash

. ~/.bash_function

if [ -f "$1.bim" ]; then


	IN=$1
	BIM=$IN.bim

	# excute time : 2018-01-31 17:06:27 : 
	perl -F'\t' -anle' $k= join ":", @F[0,3], sort(@F[4,5]); print $F[1] if $h{$k}++' $BIM > $BIM.redun


	# excute time : 2018-01-31 17:07:40 : make step2
	plink2 --bfile $IN --exclude $BIM.redun --make-bed --out $IN.NotRedunVariants --allow-no-sex --threads 10


else
	usage "PLINK"
fi



