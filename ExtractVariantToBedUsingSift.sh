#!/bin/bash

. ~/.bash_function


if [ $# -eq 2 ];then

	snpsift='java -Xmx32g -jar  /home/adminrig/src/SNPEFF/snpEff_4_3/SnpSift.jar'
	cat $1 |  $snpsift filter "(isHet(GEN[$2])) | (isHom( GEN[$2] ) & isVariant( GEN[$2] )) " |  $snpsift extractFields - CHROM POS ID REF ALT GEN[$2].GT GEN[$2].DP GEN[$2].AD > $2.tab
	AddHeader.sh $2.tab  $2.tab.header $(ls *.tab | head -1| xargs head -1 | tr "\t" "\n" | perl -nle's/^(#|(GEN.+|ANN.+)\.)//;print')
	perl -F'\t' -MMin -anle' if($.>1){ $bed=VCF2BED_0( @F[0,1,3,4], @F[3..7] ); print $bed} ' $2.tab.header > $2.tab.header.bed

else
	usage "XXX.vcf ID"
fi


