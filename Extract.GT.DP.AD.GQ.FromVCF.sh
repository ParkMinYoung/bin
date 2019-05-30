#!/bin/bash

. ~/.bash_function

if [ -f "$2" ] & [ $# -eq 2 ];then

	#ID=SPNT_012
	SIFT=/home/adminrig/src/SNPEFF/snpEff_4_3/SnpSift.jar
	ID=$1
	VCF=$2

	cat $VCF | java -Xmx32g -jar $SIFT extractFields - CHROM POS ID GEN[$ID].GT GEN[$ID].DP GEN[$ID].AD GEN[$ID].GQ | \
			perl -F"\t" -anle'
			if($.>1){
					($R,$A) = split "," , $F[5]; 
					$A=$A||0; 
					$R=$R||0; 
					$F[6]=$F[6]||0; 
					$A_Fre = $A==0 ? 0 : sprintf "%.2f", $A/$F[4]*100; 
					print join "\t", $F[0], $F[1], @F[2..$#F], $A_Fre, $A, $R  if (split ",", $F[5])+0 < 3 
			}' > $ID.metrics


	AddHeader.noheader.sh $ID.metrics $ID chr end rsid GT DP AD GQ ALT_F ALT REF
	rm -rf $ID.metrics

else
	usage "ID VCF"
fi




